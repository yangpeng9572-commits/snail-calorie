import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/auth_service.dart';

// UserProfile is in app_constants.dart - use it directly
final _activityLabels = {
  1.2: '久坐（很少運動）',
  1.375: '輕度（每週運動1-3天）',
  1.55: '中度（每週運動3-5天）',
  1.725: '高度（每週運動6-7天）',
  1.9: '極度（運動員/體力工作者）',
};

final _goalLabels = {
  'lose': '減重',
  'maintain': '維持',
  'gain': '增重',
};

/// 個人設定頁面
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late String _gender;
  late String _goal;
  late double _activityLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _gender = 'male';
    _goal = 'maintain';
    _activityLevel = 1.375;

    // 載入現有資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(userProfileProvider);
      if (profileState.profile != null) {
        final p = profileState.profile!;
        _nameController.text = p.name;
        _ageController.text = p.age.toString();
        _heightController.text = p.heightCm.toString();
        _weightController.text = p.weightKg.toString();
        setState(() {
          _gender = p.gender;
          _goal = p.goal;
          _activityLevel = p.activityLevel;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _save() {
    final profile = UserProfile(
      name: _nameController.text.isEmpty ? '使用者' : _nameController.text,
      age: int.tryParse(_ageController.text) ?? 25,
      heightCm: double.tryParse(_heightController.text) ?? 170,
      weightKg: double.tryParse(_weightController.text) ?? 65,
      gender: _gender,
      goal: _goal,
      activityLevel: _activityLevel,
    );

    ref.read(userProfileProvider.notifier).updateProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('儲存成功！')),
    );
    Navigator.pop(context);
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('登出'),
        content: const Text('確定要登出嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('登出'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authService = AuthService();
      await authService.signOut();
      ref.read(authStateProvider.notifier).state = false;
    }
  }

  Future<void> _recordWeight() async {
    final weightStr = _weightController.text.trim();
    if (weightStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入體重')),
      );
      return;
    }

    final weight = double.tryParse(weightStr);
    if (weight == null || weight <= 0 || weight > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入有效的體重值')),
      );
      return;
    }

    await ref.read(weightRecordsProvider.notifier).addWeight(DateTime.now(), weight);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('體重 ${weight.toStringAsFixed(1)} kg 已記錄')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final target = profileState.target;

    return Scaffold(
      appBar: AppBar(
        title: const Text('個人設定'),
        actions: [
          TextButton(onPressed: _signOut, child: const Text('登出', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: _save, child: const Text('儲存', style: TextStyle(color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本資料
            const Text('基本資料', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _TextField(label: '名稱', controller: _nameController, hint: '你的名字'),
            _TextField(label: '年齡（歲）', controller: _ageController, hint: '25', keyboardType: TextInputType.number),
            _TextField(label: '身高（cm）', controller: _heightController, hint: '170', keyboardType: TextInputType.number),
            _TextField(label: '體重（kg）', controller: _weightController, hint: '65', keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _recordWeight,
                icon: const Icon(Icons.monitor_weight),
                label: const Text('記錄體重'),
              ),
            ),

            const SizedBox(height: 24),

            // 性別
            const Text('性別', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _RadioChip(label: '男', value: 'male', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
                const SizedBox(width: 8),
                _RadioChip(label: '女', value: 'female', groupValue: _gender, onChanged: (v) => setState(() => _gender = v!)),
              ],
            ),

            const SizedBox(height: 24),

            // 目標
            const Text('減重目標', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _goalLabels.entries.map(
                (e) => ChoiceChip(
                  label: Text(e.value),
                  selected: _goal == e.key,
                  onSelected: (selected) {
                    if (selected) setState(() => _goal = e.key);
                  },
                ),
              ).toList(),
            ),

            const SizedBox(height: 24),

            // 活動量
            const Text('活動量', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ..._activityLabels.entries.map(
              (e) => RadioListTile<double>(
                title: Text(e.value, style: const TextStyle(fontSize: 14)),
                value: e.key,
                groupValue: _activityLevel,
                onChanged: (v) => setState(() => _activityLevel = v!),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 24),

            // 營養目標預覽
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('計算後的每日目標', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('熱量: ${target.calories} kcal'),
                    Text('碳水化合物: ${target.carbsGrams.round()}g'),
                    Text('蛋白質: ${target.proteinGrams.round()}g'),
                    Text('脂肪: ${target.fatGrams.round()}g'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 提醒設定
            const Text('提醒設定', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _NotificationSwitch(
              title: '早餐提醒',
              subtitle: '08:00',
              icon: Icons.egg_alt,
              value: ref.watch(notificationSettingsProvider).breakfastEnabled,
              onChanged: (v) => ref.read(notificationSettingsProvider.notifier).toggleBreakfast(v),
            ),
            _NotificationSwitch(
              title: '午餐提醒',
              subtitle: '12:00',
              icon: Icons.lunch_dining,
              value: ref.watch(notificationSettingsProvider).lunchEnabled,
              onChanged: (v) => ref.read(notificationSettingsProvider.notifier).toggleLunch(v),
            ),
            _NotificationSwitch(
              title: '晚餐提醒',
              subtitle: '18:00',
              icon: Icons.dinner_dining,
              value: ref.watch(notificationSettingsProvider).dinnerEnabled,
              onChanged: (v) => ref.read(notificationSettingsProvider.notifier).toggleDinner(v),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const _TextField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(hintText: hint, isDense: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _RadioChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: groupValue == value,
      onSelected: (selected) => onChanged(selected ? value : null),
    );
  }
}
