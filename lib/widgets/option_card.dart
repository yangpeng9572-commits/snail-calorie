import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// 選項卡片 - 單選/多選
/// FatSecret 風格：選中=綠邊+綠底+✓
class OptionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    required this.isSelected,
    this.isMultiSelect = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4F7DC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor 
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 左側圖示
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected 
                      ? AppTheme.primaryColor 
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : AppTheme.textPrimary,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // 右側勾選
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 22,
              )
            else if (isMultiSelect)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            else
              const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}
