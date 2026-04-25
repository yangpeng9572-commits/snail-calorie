import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareProfilePage extends ConsumerWidget {
  const ShareProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final profile = profileState.profile;
    final target = profileState.target;

    // 組合成分享文字
    final shareText = '''
🍰 食刻輕卡 - 我的營養目標
姓名：${profile?.name ?? '未設定'}
熱量目標：${target.calories} kcal
蛋白質：${target.proteinGrams.round()}g
碳水化合物：${target.carbsGrams.round()}g
脂肪：${target.fatGrams.round()}g
''';

    return Scaffold(
      appBar: AppBar(title: const Text('分享營養目標')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            QrImageView(
              data: shareText,
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(height: 24),
            Text(shareText, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => SharePlus.instance.share(
                ShareParams(text: shareText),
              ),
              icon: const Icon(Icons.share),
              label: const Text('分享文字'),
            ),
          ],
        ),
      ),
    );
  }
}
