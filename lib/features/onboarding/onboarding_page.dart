import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingPage({super.key, required this.onComplete});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingItem(
      icon: Icons.search,
      title: '搜尋食物',
      desc: '從超過 100 萬種食物中搜尋營養資訊',
      color: Colors.green,
    ),
    _OnboardingItem(
      icon: Icons.qr_code_scanner,
      title: '掃描條碼',
      desc: '掃描食品包裝上的條碼，快速找到食物',
      color: Colors.orange,
    ),
    _OnboardingItem(
      icon: Icons.bar_chart,
      title: '追蹤分析',
      desc: '記錄體重、檢視每週熱量趨勢',
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: Text('跳過'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _pages[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length,
                (i) => Container(
                  margin: EdgeInsets.all(4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? AppTheme.primaryColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    widget.onComplete();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(52),
                ),
                child: Text(_currentPage < _pages.length - 1 ? '下一步' : '開始使用'),
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
  const _OnboardingItem({
    required this.icon, required this.title,
    required this.desc, required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 80, color: color),
          ),
          SizedBox(height: 32),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
