import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/services/export_service.dart';
import '../../data/models/daily_log.dart';
import '../../providers/app_providers.dart';

/// 資料匯出頁面
class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isExporting = false;
  String? _lastExportTime;

  final ExportService _exportService = ExportService();

  @override
  void initState() {
    super.initState();
    _loadLastExportTime();
  }

  Future<void> _loadLastExportTime() async {
    final storage = ref.read(localStorageProvider);
    final lastExport = storage.getLastExportTime();
    if (lastExport != null) {
      setState(() {
        _lastExportTime = lastExport;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  List<DailyLog> _getLogsForDateRange() {
    final storage = ref.read(localStorageProvider);
    final logs = <DailyLog>[];
    var current = _startDate;
    while (!current.isAfter(_endDate)) {
      final dateStr = AppDateUtils.formatDate(current);
      final log = storage.getDailyLog(dateStr);
      if (log != null) {
        logs.add(log);
      }
      current = current.add(const Duration(days: 1));
    }
    return logs;
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final logs = _getLogsForDateRange();
      if (logs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('選定日期範圍內沒有飲食記錄')),
          );
        }
        return;
      }

      final csv = await _exportService.exportToCsv(logs);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      await _exportService.saveAndShare('食刻輕卡_$timestamp.csv', csv);

      final storage = ref.read(localStorageProvider);
      await storage.saveLastExportTime(DateTime.now().toIso8601String());

      setState(() {
        _lastExportTime = DateTime.now().toIso8601String();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已匯出 ${logs.length} 天的記錄')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('匯出失敗：$e')),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportJson() async {
    setState(() => _isExporting = true);
    try {
      final logs = _getLogsForDateRange();
      if (logs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('選定日期範圍內沒有飲食記錄')),
          );
        }
        return;
      }

      final jsonStr = await _exportService.exportToJson(logs);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      await _exportService.saveAndShare('食刻輕卡_$timestamp.json', jsonStr);

      final storage = ref.read(localStorageProvider);
      await storage.saveLastExportTime(DateTime.now().toIso8601String());

      setState(() {
        _lastExportTime = DateTime.now().toIso8601String();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已匯出 ${logs.length} 天的記錄')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('匯出失敗：$e')),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('資料匯出'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 說明卡片
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '飲食記錄匯出',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '將您的飲食記錄匯出為 CSV 或 JSON 格式，方便備份或在 Excel 中分析。',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 日期範圍選擇
            const Text(
              '選擇日期範圍',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DateSelector(
                    label: '開始日期',
                    date: dateFormat.format(_startDate),
                    onTap: _selectStartDate,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: Colors.grey),
                ),
                Expanded(
                  child: _DateSelector(
                    label: '結束日期',
                    date: dateFormat.format(_endDate),
                    onTap: _selectEndDate,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 匯出按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isExporting ? null : _exportCsv,
                icon: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.table_chart),
                label: const Text('匯出 CSV'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isExporting ? null : _exportJson,
                icon: const Icon(Icons.code),
                label: const Text('匯出 JSON'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 上一次匯出時間
            if (_lastExportTime != null) ...[
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '上一次匯出：${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(_lastExportTime!))}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // 格式說明
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '匯出格式說明',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    _FormatItem(
                      icon: Icons.table_chart,
                      title: 'CSV 格式',
                      description: '可用 Excel 或 Google 試算表開啟，適合快速分析。',
                    ),
                    SizedBox(height: 8),
                    _FormatItem(
                      icon: Icons.code,
                      title: 'JSON 格式',
                      description: '包含完整資料結構，適合程式處理或資料庫匯入。',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;

  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FormatItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
