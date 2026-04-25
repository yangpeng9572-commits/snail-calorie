import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/exercise_entry.dart';
import '../../providers/app_providers.dart';

/// 運動記錄頁面
class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  PredefinedExercise? _selectedExercise;
  final TextEditingController _durationController = TextEditingController();
  double _calculatedCalories = 0;
  int _selectedDuration = 30;

  @override
  void initState() {
    super.initState();
    // 載入今日運動記錄
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = AppDateUtils.todayString();
      ref.read(exerciseLogProvider.notifier).loadExercises(today);
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _calculateCalories(PredefinedExercise exercise, int duration) {
    final profileState = ref.read(userProfileProvider);
    final weight = profileState.profile?.weightKg ?? 70.0; // 預設體重 70kg
    setState(() {
      _calculatedCalories = exercise.calculateCalories(weight, duration);
    });
  }

  Future<void> _saveExercise() async {
    if (_selectedExercise == null) return;

    final dateStr = AppDateUtils.todayString();
    final entry = ExerciseEntry(
      name: _selectedExercise!.name,
      duration: _selectedDuration,
      caloriesBurned: _calculatedCalories,
      date: dateStr,
    );

    await ref.read(exerciseLogProvider.notifier).addEntry(entry);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已儲存 ${_selectedExercise!.name} - 燃燒 ${_calculatedCalories.round()} kcal'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      setState(() {
        _selectedExercise = null;
        _durationController.clear();
        _selectedDuration = 30;
        _calculatedCalories = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayExercises = ref.watch(exerciseLogProvider);
    final todayStr = AppDateUtils.todayString();
    final todayTotal = todayExercises
        .where((e) => e.date == todayStr)
        .fold(0.0, (sum, e) => sum + e.caloriesBurned);

    return Scaffold(
      appBar: AppBar(
        title: const Text('運動記錄'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 今日運動概覽
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      icon: Icons.local_fire_department,
                      value: todayTotal.round().toString(),
                      label: '今日燃燒',
                      color: AppTheme.calorieColor,
                    ),
                    _SummaryItem(
                      icon: Icons.fitness_center,
                      value: todayExercises.where((e) => e.date == todayStr).length.toString(),
                      label: '運動次數',
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 運動類型選擇
            const Text(
              '選擇運動類型',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: PredefinedExercises.all.length,
              itemBuilder: (context, index) {
                final exercise = PredefinedExercises.all[index];
                final isSelected = _selectedExercise?.name == exercise.name;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExercise = exercise;
                    });
                    _calculateCalories(exercise, _selectedDuration);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          exercise.icon,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppTheme.primaryColor : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 時間輸入
            const Text(
              '運動時間（分鐘）',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [15, 30, 45, 60, 90].map((mins) {
                final isSelected = _selectedDuration == mins;
                return ChoiceChip(
                  label: Text('$mins'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDuration = mins;
                      });
                      if (_selectedExercise != null) {
                        _calculateCalories(_selectedExercise!, mins);
                      }
                    }
                  },
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _selectedDuration.toDouble(),
                    min: 5,
                    max: 180,
                    divisions: 35,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value.round();
                      });
                      if (_selectedExercise != null) {
                        _calculateCalories(_selectedExercise!, _selectedDuration);
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_selectedDuration 分鐘',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 卡路里計算結果
            if (_selectedExercise != null)
              Card(
                color: AppTheme.calorieColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department, color: AppTheme.calorieColor),
                          const SizedBox(width: 8),
                          Text(
                            '預估燃燒 ${_calculatedCalories.round()} kcal',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.calorieColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_selectedExercise!.name} × $_selectedDuration 分鐘',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('儲存運動記錄'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // 今日運動列表
            const Text(
              '今日運動記錄',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildExerciseList(todayExercises.where((e) => e.date == todayStr).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList(List<ExerciseEntry> entries) {
    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.fitness_center, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  '今日還沒有運動記錄',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: entries.map((entry) {
        final exercise = PredefinedExercises.findByName(entry.name);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Text(
                exercise?.icon ?? '🏃',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(entry.name),
            subtitle: Text('${entry.duration} 分鐘'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${entry.caloriesBurned.round()} kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calorieColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(entry),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _confirmDelete(ExerciseEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('刪除確認'),
        content: Text('確定要刪除「${entry.name}」運動記錄嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(exerciseLogProvider.notifier).removeEntry(entry.id);
            },
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// 摘要項目widget
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
