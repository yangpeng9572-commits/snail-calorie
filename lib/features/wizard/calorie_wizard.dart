import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class CalorieWizard extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  const CalorieWizard({super.key, required this.onComplete});
  @override
  ConsumerState<CalorieWizard> createState() => _CalorieWizardState();
}

class _CalorieWizardState extends ConsumerState<CalorieWizard> {
  final _pageController = PageController();
  int _step = 0;

  // Step 0: 性別
  String _gender = 'male';
  // Step 1: 年齡
  double _age = 25;
  // Step 2: 身高 (cm)
  double _height = 170;
  // Step 3: 體重 (kg)
  double _weight = 65;
  // Step 4: 活動量
  String _activity = 'moderate';
  // Step 5: 目標（減重/維持/增重）
  String _goal = 'maintain';

  final _activities = {
    'sedentary': '久坐（很少運動）',
    'light': '輕度（每週運動 1-3 天）',
    'moderate': '中度（每週運動 3-5 天）',
    'active': '活躍（每週運動 6-7 天）',
  };

  final _goals = {
    'lose': '減肥（每週減 0.5kg）',
    'maintain': '維持體重',
    'gain': '增肌（每週增 0.5kg）',
  };

  double _getActivityLevel(String activity) {
    switch (activity) {
      case 'sedentary':
        return 1.2;
      case 'light':
        return 1.375;
      case 'moderate':
        return 1.55;
      case 'active':
        return 1.725;
      default:
        return 1.55;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定營養目標')),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildGenderStep(),
          _buildAgeStep(),
          _buildHeightStep(),
          _buildWeightStep(),
          _buildActivityStep(),
          _buildGoalStep(),
          _buildSummaryStep(),
        ],
      ),
    );
  }

  Widget _buildGenderStep() => _buildStep(
    title: '你的性別是？',
    subtitle: '用於計算基礎代謝率',
    child: Column(
      children: [
        _buildOption('male', '♂ 男性', Icons.male),
        const SizedBox(height: 16),
        _buildOption('female', '♀ 女性', Icons.female),
      ],
    ),
  );

  Widget _buildAgeStep() => _buildStep(
    title: '你的年齡',
    subtitle: '${_age.toInt()} 歲',
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_age.toInt()} 歲',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // 數字選擇 Row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [20, 25, 30, 35, 40, 45, 50].map((v) => _QuickSelectChip(
            label: '$v',
            isSelected: _age.toInt() == v,
            onTap: () => setState(() => _age = v.toDouble()),
          )).toList(),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _age,
          min: 10,
          max: 80,
          divisions: 70,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
          onChanged: (v) => setState(() => _age = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('10歲', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text('80歲', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ],
    ),
  );

  Widget _buildHeightStep() => _buildStep(
    title: '你的身高',
    subtitle: '${_height.toInt()} cm',
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_height.toInt()} cm',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [160, 165, 170, 175, 180, 185].map((v) => _QuickSelectChip(
            label: '$v',
            isSelected: _height.toInt() == v,
            onTap: () => setState(() => _height = v.toDouble()),
          )).toList(),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _height,
          min: 120,
          max: 220,
          divisions: 100,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
          onChanged: (v) => setState(() => _height = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('120cm', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text('220cm', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ],
    ),
  );

  Widget _buildWeightStep() => _buildStep(
    title: '你的體重',
    subtitle: '${_weight.toStringAsFixed(1)} kg',
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_weight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [50, 55, 60, 65, 70, 75, 80].map((v) => _QuickSelectChip(
            label: '$v',
            isSelected: (_weight - v).abs() < 0.5,
            onTap: () => setState(() => _weight = v.toDouble()),
          )).toList(),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _weight,
          min: 30,
          max: 200,
          divisions: 170,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
          onChanged: (v) => setState(() => _weight = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('30kg', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text('200kg', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ],
    ),
  );

  Widget _buildActivityStep() => _buildStep(
    title: '你的活動量',
    subtitle: '每週運動頻率',
    child: Column(
      children: _activities.entries.map((e) => _buildOption(e.key, e.value, Icons.directions_run)).toList(),
    ),
  );

  Widget _buildGoalStep() => _buildStep(
    title: '你的目標',
    subtitle: '選擇你想要的方式',
    child: Column(
      children: _goals.entries.map((e) => _buildOption(e.key, e.value, Icons.flag)).toList(),
    ),
  );

  Widget _buildSummaryStep() {
    final bmr = _gender == 'male'
        ? (10 * _weight) + (6.25 * _height) - (5 * _age) + 5
        : (10 * _weight) + (6.25 * _height) - (5 * _age) - 161;
    final activityMult = {'sedentary': 1.2, 'light': 1.375, 'moderate': 1.55, 'active': 1.725}[_activity]!;
    final goalAdjust = {'lose': -500.0, 'maintain': 0.0, 'gain': 300.0}[_goal]!;
    final tdee = bmr * activityMult;
    final targetCal = tdee + goalAdjust;
    // 巨量營養素建議
    final targetProtein = _weight * 1.6; // 蛋白質：體重 × 1.6g
    final targetFat = (targetCal * 0.25) / 9; // 脂肪：熱量 × 25% ÷ 9
    final targetCarbs = (targetCal - (targetProtein * 4) - (targetFat * 9)) / 4; // 碳水：剩餘熱量 ÷ 4

    return _buildStep(
      title: '你的每日熱量目標',
      subtitle: '根據你的資料計算',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '${targetCal.toInt()}',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'kcal / 每日',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '蛋白質: ${(targetProtein * 1.6).round()}g  ·  脂肪: ${targetFat.round()}g  ·  碳水: ${(targetCarbs).round()}g',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final profile = UserProfile(
                  name: '使用者',
                  age: _age.toInt(),
                  heightCm: _height,
                  weightKg: _weight,
                  gender: _gender,
                  goal: _goal,
                  activityLevel: _getActivityLevel(_activity),
                );
                ref.read(userProfileProvider.notifier).updateProfile(profile);
                Navigator.of(context).pop();
                widget.onComplete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                '確認開始使用',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String value, String label, IconData icon) {
    final selected = (_gender == value) || (_activity == value) || (_goal == value);
    return InkWell(
      onTap: () {
        setState(() {
          if (_step == 0) {
            _gender = value;
          } else if (_step == 4) {
            _activity = value;
          } else if (_step == 5) {
            _goal = value;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppTheme.primaryColor.withOpacity(0.08) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor.withOpacity(0.15)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: selected ? AppTheme.primaryColor : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? AppTheme.primaryColor : AppTheme.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String title, String? subtitle, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 步進指示
          Row(
            children: List.generate(7, (i) {
              final isCompleted = i < _step;
              final isCurrent = i == _step;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 32),
          Expanded(child: child),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_step > 0)
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    setState(() => _step--);
                  },
                  child: const Text('上一步'),
                )
              else
                const SizedBox(),
              const Spacer(),
              if (_step < 6)
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      setState(() => _step++);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('下一步'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 快速選擇Chip - FatSecret風格圓角按鈕
class _QuickSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickSelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
