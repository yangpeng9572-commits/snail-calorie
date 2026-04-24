import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/services/local_storage_service.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'features/charts/charts_page.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地儲存
  final storage = await LocalStorageService.create();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
      child: const SnailCalorieApp(),
    ),
  );
}

class SnailCalorieApp extends StatelessWidget {
  const SnailCalorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '食刻輕卡',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationPage(),
      routes: {
        '/profile': (_) => const ProfilePage(),
        '/charts': (_) => const ChartsPage(),
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
