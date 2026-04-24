import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('隱私權政策')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('一、資訊收集', '''
食刻輕卡重視您的隱私權。本應用程式（以下簡稱「本 App」）不會在您不知情的情況下收集個人資料。

當您使用本 App 時，我們可能收集以下資訊：
• 飲食記錄（食物名稱、熱量、營養素）
• 體重與身體數據（身高、年齡、性別）
• 裝置資訊（用於改善服務品質）
            '''),
            _buildSection('二、資料儲存', '''
您的飲食記錄與個人資料儲存在您的裝置本機，以及您授權的雲端服務（Firebase）。我們不會將您的資料用於廣告或商業目的。
            '''),
            _buildSection('三、第三方服務', '''
本 App 使用以下第三方服務：
• Open Food Facts（食物資料庫）：用於查詢食物營養資訊
• Firebase（Google）：用於雲端資料同步（需使用者主動登入）
            '''),
            _buildSection('四、資料分享', '''
我們不會出售、交易或轉讓您的個人身份資料給外部第三方。
            '''),
            _buildSection('五、兒童隱私', '''
本 App 不針對 13 歲以下兒童設計，我們不會故意收集未成年人的個人資料。
            '''),
            _buildSection('六、政策變更', '''
我們可能不時更新本隱私權政策。如有重大變更，我們將通過 App 內通知告知您。
            '''),
            _buildSection('七、聯絡我們', '''
如果您對本隱私權政策有任何疑問，請聯絡：yangpeng9572@gmail.com

最後更新日期：2025年4月
            '''),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content.trim(), style: const TextStyle(fontSize: 15, height: 1.6)),
        ],
      ),
    );
  }
}
