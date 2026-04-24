import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私權政策'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最後更新：2024年',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              '食刻輕卡非常重視您的隱私。',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '📊 我們收集的資料\n'
              '我們僅收集您主動提供的資料：體重、飲食記錄、營養目標。這些資料儲存在您的手機本機，以及您選擇連結的 Firebase 雲端服務中。\n\n'
              '🔒 資料安全\n'
              '您的資料使用 Firebase 加密傳輸和儲存。我們不會將您的個人資料出售或分享給任何第三方廣告商。\n\n'
              '🍎 Apple HealthKit（iOS）\n'
              '本 App 未使用 Apple HealthKit API。\n\n'
              '📱 兒童隱私\n'
              '本 App 不面向 13 歲以下兒童，我們不會故意收集兒童的個人資料。\n\n'
              '📝 政策變更\n'
              '若我們的隱私權政策有任何變更，會在 App 更新時通知您。\n\n'
              '📧 聯絡我們\n'
              '如有任何隱私相關問題，請聯繫：yangpeng9572@gmail.com',
              style: TextStyle(fontSize: 15, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
