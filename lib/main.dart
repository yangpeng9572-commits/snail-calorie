import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_dark.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/firestore_service.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'features/charts/charts_page.dart';
import 'features/auth/login_page.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地儲存
  final storage = await LocalStorageService.create();
  final firestore = await FirestoreService.create();

  // 初始化 Guest 模式
  final authService = AuthService();
  await authService.initGuestMode();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
        firestoreServiceProvider.overrideWithValue(firestore),
        authServiceProvider.overrideWithValue(authService),
      ],
      child: const SnailCalorieApp(),
    ),
  );
}

/// Auth 服務 Provider（需要手動 override）
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError('AuthService must be overridden at startup');
});

class SnailCalorieApp extends ConsumerWidget {
  const SnailCalorieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: '食刻輕卡',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppThemeDark.darkTheme,
      themeMode: themeMode,
      home: const AuthGate(),
      routes: {
        '/profile': (_) => const ProfilePage(),
        '/charts': (_) => const ChartsPage(),
      },
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Guest 模式直接通過
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() => _isInitialized = true);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '分析',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
