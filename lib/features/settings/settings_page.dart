import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';

/// 設定頁面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('設定', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 關於區塊
          const _SectionHeader(title: '關於'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('版本資訊'),
            subtitle: Text('版本 1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text('營養目標說明'),
            subtitle: const Text('了解熱量與營養素的計算方式'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showNutritionExplanation(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('隱私權政策'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),

          const Divider(),

          // 資料管理區塊
          const _SectionHeader(title: '資料管理'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              '清除本地資料',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('刪除所有本地儲存的資料'),
            onTap: () => _showClearDataConfirmation(context, ref),
          ),
        ],
      ),
    );
  }

  /// 顯示營養目標說明（Mifflin-St Jeor 公式）
  void _showNutritionExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('營養目標計算說明'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '📊 基礎代謝率 (BMR)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '本 App 使用 Mifflin-St Jeor 公式計算基礎代謝率：\n\n'
                '男性：BMR = 10×體重(kg) + 6.25×身高(cm) - 5×年齡 + 5\n'
                '女性：BMR = 10×體重(kg) + 6.25×身高(cm) - 5×年齡 - 161',
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                '🔥 每日總消耗熱量 (TDEE)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'TDEE = BMR × 活動係數\n\n'
                '• 久坐（很少運動）：× 1.2\n'
                '• 輕度（每週運動1-3天）：× 1.375\n'
                '• 中度（每週運動3-5天）：× 1.55\n'
                '• 高度（每週運動6-7天）：× 1.725\n'
                '• 極度（運動員/體力工作者）：× 1.9',
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                '🎯 熱量目標調整',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '根據您的目標調整：\n'
                '• 減重：TDEE × 0.8（每日減少 20% 熱量）\n'
                '• 維持：TDEE（保持當前攝取量）\n'
                '• 增重：TDEE × 1.1（每日增加 10% 熱量）',
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                '🥗 營養素分配',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '本 App 建議的三大營養素比例：\n'
                '• 蛋白質：20-30%（每公斤體重 1.2-1.6g）\n'
                '• 脂肪：25-35%（約占總熱量）\n'
                '• 碳水化合物：40-50%（其餘熱量來源）',
                style: TextStyle(height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  /// 顯示清除資料二次確認
  void _showClearDataConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('警告'),
        content: const Text(
          '確定要清除所有本地資料嗎？\n此操作無法恢復。',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _clearAllDataAndRestart(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('確定清除'),
          ),
        ],
      ),
    );
  }

  /// 清除所有資料並重啟 App
  Future<void> _clearAllDataAndRestart(BuildContext context, WidgetRef ref) async {
    final storage = ref.read(localStorageProvider);
    await storage.clearAll();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已清除所有本地資料')),
      );

      // 等待一段時間讓用戶看到訊息，然後重啟
      await Future.delayed(const Duration(seconds: 1));

      // 使用 restartApp 方法重啟應用
      if (context.mounted) {
        _restartApp(context);
      }
    }
  }

  /// 重啟 App（透過 Navigator 回到根頁面）
  void _restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
  }
}

/// 區塊標題元件
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
