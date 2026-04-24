import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../providers/app_providers.dart';
import '../../data/models/food_item.dart';
import '../../core/theme/app_theme.dart';

/// 條碼掃描頁面
class BarcodeScannerPage extends ConsumerStatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  ConsumerState<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  MobileScannerController? _controller;
  bool _isScanning = true;
  String? _lastScanned;
  FoodItem? _foundFood;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null || barcode == _lastScanned) return;

    _lastScanned = barcode;
    setState(() => _isScanning = false);

    _lookupBarcode(barcode);
  }

  Future<void> _lookupBarcode(String barcode) async {
    final service = ref.read(openFoodFactsServiceProvider);
    final food = await service.getFoodByBarcode(barcode);

    if (!mounted) return;

    setState(() {
      _foundFood = food;
      _isScanning = food != null;
    });

    if (food == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('找不到條碼 $barcode 對應的食品')),
      );
      // 1.5秒後繼續掃描
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isScanning = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('掃描條碼'),
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.flash_off : Icons.flash_on),
            onPressed: () => _controller?.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller?.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                // 掃描框裝飾
                Center(
                  child: Container(
                    width: 280,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                if (_isScanning)
                  const Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Text(
                      '將條碼對準掃描框',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16, shadows: [
                        Shadow(blurRadius: 4, color: Colors.black),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _foundFood != null
                ? _FoodResultCard(food: _foundFood!)
                : const Center(child: Text('準備掃描...')),
          ),
        ],
      ),
    );
  }
}

class _FoodResultCard extends ConsumerWidget {
  final FoodItem food;

  const _FoodResultCard({required this.food});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fastfood, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    food.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (food.brand != null)
              Text(food.brand!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NutrientChip(label: '熱量', value: '${food.calories.round()}', unit: 'kcal', color: AppTheme.calorieColor),
                _NutrientChip(label: '碳水', value: '${food.carbs.round()}', unit: 'g', color: AppTheme.carbsColor),
                _NutrientChip(label: '蛋白', value: '${food.protein.round()}', unit: 'g', color: AppTheme.proteinColor),
                _NutrientChip(label: '脂肪', value: '${food.fat.round()}', unit: 'g', color: AppTheme.fatColor),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: ['早餐', '午餐', '晚餐', '點心'].map(
                (meal) => ElevatedButton(
                  onPressed: () {
                    ref.read(dailyLogProvider.notifier).addEntry(meal, food, 100);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已新增到 $meal（100g）')),
                    );
                  },
                  child: Text('+$meal'),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutrientChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
