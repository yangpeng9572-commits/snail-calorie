import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/theme/app_theme.dart';

class CameraSearchPage extends ConsumerStatefulWidget {
  const CameraSearchPage({super.key});

  @override
  ConsumerState<CameraSearchPage> createState() => _CameraSearchPageState();
}

class _CameraSearchPageState extends ConsumerState<CameraSearchPage> {
  final _picker = ImagePicker();
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    if (!mounted) return;
    
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    
    try {
      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognized = await textRecognizer.processImage(inputImage);
      
      await textRecognizer.close();
      
      if (!mounted) return;
      
      // 提取所有非空行並選擇最長的行（通常是食物名稱）
      final lines = recognized.text
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .toList();
      
      if (lines.isNotEmpty) {
        // 選擇最長的行通常是最完整的食物名稱
        final foodName = lines.reduce((a, b) => a.length > b.length ? a : b).trim();
        
        // 自動跳轉搜尋頁並帶入食物名稱
        Navigator.of(context).pop(foodName);
      } else {
        setState(() {
          _isProcessing = false;
          _errorMessage = '找不到文字，請拍攝食物包裝上的文字或標籤';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = '無法處理圖片：$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拍照搜尋'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isProcessing
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在分析圖片...', style: TextStyle(fontSize: 16)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('拍下食物包裝上的文字', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    '功能說明：讀取包裝上的食物名稱文字',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '建議：拍攝營養標示或包裝標籤上的文字',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera),
                    label: const Text('拍照'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
