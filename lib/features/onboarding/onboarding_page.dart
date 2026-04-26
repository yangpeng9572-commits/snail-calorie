import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../wizard/calorie_wizard.dart';

/// 歡迎/引導頁面 - FatSecret 簡約風格
class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  // 所有引導頁面（隱私權 + 功能介紹）
  List<Widget> get _allPages => [
    const _PrivacyConsentPage(),
    const _OnboardingItem(
      icon: Icons.restaurant_menu,
      title: '記錄你的飲食',
      desc: '輕鬆搜尋與記錄每一餐\n從在地美食到連鎖餐廳',
      color: AppTheme.primaryColor,
      bgColor: Color(0xFFE8F5E9),
    ),
    const _OnboardingItem(
      icon: Icons.qr_code_scanner,
      title: '掃描條碼',
      desc: '一拍即知營養資訊\n再也不用猜熱量',
      color: AppTheme.accentColor,
      bgColor: Color(0xFFFFF3E0),
    ),
    const _OnboardingItem(
      icon: Icons.trending_up,
      title: '追蹤你的進度',
      desc: '每週分析熱量趨勢\n看見你的成果',
      color: AppTheme.carbsColor,
      bgColor: Color(0xFFE3F2FD),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 跳過按鈕
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: const Text(
                  '跳過',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // 頁面內容
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _allPages.length,
                itemBuilder: (_, i) => _allPages[i],
              ),
            ),

            // 指示器
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _allPages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 按鈕區域
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // 主按鈕
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _allPages.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CalorieWizard(onComplete: widget.onComplete),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage < _allPages.length - 1 ? '下一步' : '開始使用',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage < _allPages.length - 1) ...[
                    const SizedBox(height: 12),
                    // 次要按鈕
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CalorieWizard(onComplete: widget.onComplete),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '直接開始',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final Color bgColor;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖示圓圈
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 56,
              color: color,
            ),
          ),
          const SizedBox(height: 40),
          // 標題
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 說明
          Text(
            desc,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 隱私權同意頁 - FatSecret 風格
class _PrivacyConsentPage extends StatelessWidget {
  const _PrivacyConsentPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // 圖示
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // 標題
          const Text(
            '開始使用前',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 說明
          Text(
            '食刻輕卡的使命是幫助你達成營養目標。我們致力於保護你的隱私並確保資料安全。',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // 資料使用方式
          const Text(
            '我們如何使用您的資料',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _PrivacyItem(
            icon: Icons.restaurant,
            title: '個人化目標',
            desc: '使用你的個人和健康資料來提供營養建議和每日熱量攝取量。',
          ),
          const SizedBox(height: 12),
          _PrivacyItem(
            icon: Icons.school,
            title: '教育與指引',
            desc: '根據你的活動記錄，提供食物營養教育內容及功能使用建議。',
          ),
          const SizedBox(height: 12),
          _PrivacyItem(
            icon: Icons.analytics,
            title: '平台改善',
            desc: '使用匿名分析資料來了解使用者行為，藉此改善我們的服務。',
          ),
          const SizedBox(height: 24),
          // 提示框
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '點擊「同意」即表示你已詳閱並同意我們的隱私權政策。你可隨時在設定中更改偏好。',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
