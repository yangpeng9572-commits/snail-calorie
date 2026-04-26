import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// 自定義數字鍵盤 - FatSecret/Duolingo 風格
/// 大圓角按鍵 + 統一的配色
class CustomNumberPad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback onConfirm;
  final bool showDecimal;

  const CustomNumberPad({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    required this.onConfirm,
    this.showDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F1F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 第一行：1 2 3
          Row(
            children: [
              _buildKey('1'),
              _buildKey('2'),
              _buildKey('3'),
            ],
          ),
          const SizedBox(height: 8),
          // 第二行：4 5 6
          Row(
            children: [
              _buildKey('4'),
              _buildKey('5'),
              _buildKey('6'),
            ],
          ),
          const SizedBox(height: 8),
          // 第三行：7 8 9
          Row(
            children: [
              _buildKey('7'),
              _buildKey('8'),
              _buildKey('9'),
            ],
          ),
          const SizedBox(height: 8),
          // 第四行：小數點 刪除 確認
          Row(
            children: [
              _buildKey(showDecimal ? '.' : '', isEnabled: showDecimal),
              _buildDeleteKey(),
              _buildConfirmKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, {bool isEnabled = true}) {
    if (label.isEmpty && !isEnabled) {
      return Expanded(child: Container(height: 56));
    }
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 0,
          child: InkWell(
            onTap: isEnabled && label.isNotEmpty ? () => onKeyPressed(label) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isEnabled ? AppTheme.textPrimary : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.backspace_outlined,
                size: 24,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmKey() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onConfirm,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_right,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
