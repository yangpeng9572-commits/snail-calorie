import 'package:flutter/material.dart';

/// 資訊框 - 左側灰豎線+i圖示
/// 用於提示、說明、注意事項
class InfoBox extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final IconData? icon;

  const InfoBox({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE9ECEF),
    this.borderColor = const Color(0xFF6C757D),
    this.textColor = const Color(0xFF495057),
    this.icon,
  });

  /// 藍色版本（提示/小建議）
  factory InfoBox.tip({
    required String text,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    IconData? icon,
  }) {
    return InfoBox(
      text: text,
      backgroundColor: backgroundColor ?? const Color(0xFFEBF5FF),
      borderColor: borderColor ?? const Color(0xFF4584FF),
      textColor: textColor ?? const Color(0xFF333333),
      icon: icon ?? Icons.lightbulb_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
