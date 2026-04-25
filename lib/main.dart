import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// Firebase Crashlytics
if (Firebase.apps.isNotEmpty) {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_dark.dart';
import 'core/widgets/page_transitions.dart';
import 'core/widgets/offline_banner.dart';
import 'core/l10n/app_localizations.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/firestore_service.dart';
import 'data/services/exercise_service.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'features/charts/charts_page.dart';
import 'features/auth/login_page.dart';
import 'features/export/export_page.dart';
import 'features/share/share_profile_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/splash/splash_page.dart';
import 'features/settings/privacy_policy_page.dart';
import 'features/settings/settings_page.dart';
import 'features/favorites/favorites_page.dart';
import 'features/exercise/exercise_page.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地儲存
  final storage = await LocalStorageService.create();
  final firestore = await FirestoreService.create();
  final prefs = await SharedPreferences.getInstance();

  // 初始化 Guest 模式
  final authService = AuthService();
  await authService.initGuestMode();

  // 初始化運動服務
  final exerciseService = ExerciseService(prefs);

  // 設定快捷動作
  // ignore: prefer_const_constructors (QuickActions from quick_actions package)
  final quickActions = QuickActions();
  quickActions.setShortcutItems([
    const ShortcutItem(type: 'breakfast', localizedTitle: '新增早餐', localizedSubtitle: '快速記錄早餐', icon: 'ic_launcher'),
    const ShortcutItem(type: 'weight', localizedTitle: '記錄體重', localizedSubtitle: '開啟體重記錄', icon: 'ic_launcher'),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
        firestoreServiceProvider.overrideWithValue(firestore),
        authServiceProvider.overrideWithValue(authService),
        exerciseServiceProvider.overrideWithValue(exerciseService),
      ],
      child: const SnailCalorieApp(),
    ),
  );
}

/// Auth 服務 Provider（需要手動 override）
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError('AuthService must be overridden at startup');
});

class SnailCalorieApp extends ConsumerStatefulWidget {
  const SnailCalorieApp({super.key});

  @override
  ConsumerState<SnailCalorieApp> createState() => _SnailCalorieAppState();
}

class _SnailCalorieAppState extends ConsumerState<SnailCalorieApp> {
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors (QuickActions from quick_actions package)
    QuickActions().initialize((String? type) {
      if (type == 'breakfast') {
        // 導航到新增早餐頁
        Navigator.pushNamed(context, '/add-food', arguments: '早餐');
      } else if (type == 'weight') {
        // 導航到記錄體重（目前使用現有對話框）
        _showWeightDialog(context);
      }
    });
  }

  void _showWeightDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('記錄體重'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '體重 (kg)',
            hintText: '例如：65.5',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(controller.text);
              if (weight != null && weight > 0) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('體重 $weight kg 已記錄')),
                );
              }
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final localeCode = ref.watch(localeProvider);
    final l10n = AppLocalizations(localeCode);

    return OfflineBanner(
      child: MaterialApp(
      title: l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppThemeDark.darkTheme,
      themeMode: themeMode,
      locale: Locale(localeCode),
      supportedLocales: const [Locale('zh'), Locale('en')],
      home: const SplashPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            return SlidePageRoute(page: const ProfilePage());
          case '/charts':
            return SlidePageRoute(page: const ChartsPage());
          case '/export':
            return SlidePageRoute(page: const ExportPage());
          case '/share-profile':
            return SlidePageRoute(page: const ShareProfilePage());
          case '/splash':
            return SlidePageRoute(page: const SplashPage());
          case '/privacy-policy':
            return SlidePageRoute(page: const PrivacyPolicyPage());
          case '/settings':
            return SlidePageRoute(page: const SettingsPage());
          case '/favorites':
            return SlidePageRoute(page: const FavoritesPage());
          case '/exercise':
            return SlidePageRoute(page: const ExercisePage());
          default:
            return null;
        }
      },
      ),
    );
  }
}

/// 登入閘道（檢查是否已登入，決定顯示 LoginPage 或 MainNavigationPage）
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isInitialized = false;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Guest 模式直接通過
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      // 檢查是否需要顯示首次使用引導
      final storage = ref.read(localStorageProvider);
      final hasCompletedOnboarding = storage.hasCompletedOnboarding();
      setState(() {
        _showOnboarding = !hasCompletedOnboarding;
        _isInitialized = true;
      });
    }
  }

  Future<void> _onOnboardingComplete() async {
    final storage = ref.read(localStorageProvider);
    await storage.setOnboardingComplete();
    if (mounted) {
      setState(() => _showOnboarding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                '食刻輕卡',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    // 顯示首次使用引導
    if (_showOnboarding) {
      return OnboardingPage(onComplete: _onOnboardingComplete);
    }

    // 使用 authStateProvider 判斷是否已登入
    final isAuthenticated = ref.watch(authStateProvider);
    if (isAuthenticated) {
      return const MainNavigationPage();
    }
    return LoginPage(
      onSignInSuccess: () {
        ref.read(authStateProvider.notifier).state = true;
      },
    );
  }
}

/// 主導航頁面（含底部導航列）
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    ChartsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home,
                  label: '首頁',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.bar_chart,
                  label: '分析',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.person,
                  label: '設定',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 自定義底部導航項目
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;


  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
