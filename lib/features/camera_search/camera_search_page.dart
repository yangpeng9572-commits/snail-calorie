import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraSearchPage extends ConsumerStatefulWidget {
  const CameraSearchPage({super.key});

  @override
  ConsumerState<CameraSearchPage> createState() => _CameraSearchPageState();
}

class _CameraSearchPageState extends ConsumerState<CameraSearchPage> {
  final _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    if (!mounted) return;
    
    setState(() => _isProcessing = true);
    
    final inputImage = InputImage.fromFilePath(photo.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognized = await textRecognizer.processImage(inputImage);
    
    // 提取食物名稱（第一行或最長的行）
    final lines = recognized.text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    
    await textRecognizer.close();
    
    if (!mounted) return;
    
    if (lines.isNotEmpty) {
      final foodName = lines.first.trim();
      // 自動跳轉搜尋頁
      Navigator.of(context).pop(foodName);
    } else {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('拍照搜尋')),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('拍下食物包裝或餐點', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera),
                    label: const Text('拍照'),
                  ),
                ],
              ),
      ),
    );
  }
}
