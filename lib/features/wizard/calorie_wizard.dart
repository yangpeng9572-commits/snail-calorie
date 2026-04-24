import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
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
    child: Column(
      children: [
        Text('${_age.toInt()} 歲', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        Slider(
          value: _age,
          min: 10,
          max: 80,
          divisions: 70,
          onChanged: (v) => setState(() => _age = v),
        ),
      ],
    ),
  );

  Widget _buildHeightStep() => _buildStep(
    title: '你的身高',
    child: Column(
      children: [
        Text('${_height.toInt()} cm', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        Slider(
          value: _height,
          min: 120,
          max: 220,
          divisions: 100,
          onChanged: (v) => setState(() => _height = v),
        ),
      ],
    ),
  );

  Widget _buildWeightStep() => _buildStep(
    title: '你的體重',
    child: Column(
      children: [
        Text('${_weight.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        Slider(
          value: _weight,
          min: 30,
          max: 200,
          divisions: 170,
          onChanged: (v) => setState(() => _weight = v),
        ),
      ],
    ),
  );

  Widget _buildActivityStep() => _buildStep(
    title: '你的活動量',
    child: Column(
      children: _activities.entries.map((e) => _buildOption(e.key, e.value, Icons.directions_run)).toList(),
    ),
  );

  Widget _buildGoalStep() => _buildStep(
    title: '你的目標',
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

    return _buildStep(
      title: '你的每日熱量目標',
      child: Column(
        children: [
          Text(
            '${targetCal.toInt()} kcal',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),
          const Text('這是根據你的資料計算出來的建議攝取量', textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton(
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
              // 存入 provider
              ref.read(userProfileProvider.notifier).updateProfile(profile);
              Navigator.of(context).pop();
              widget.onComplete();
            },
            child: const Text('確認開始使用'),
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
          border: Border.all(color: selected ? Colors.green : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: selected ? Colors.green.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          child,
          const Spacer(),
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
                ),
              const Spacer(),
              if (_step < 6)
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    setState(() => _step++);
                  },
                  child: const Text('下一步'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
