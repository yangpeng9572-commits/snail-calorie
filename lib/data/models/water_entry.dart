/// 喝水記錄項目
class WaterEntry {
  final String id;
  final double ml; // 毫升
  final DateTime loggedAt;

  WaterEntry({
    String? id,
    required this.ml,
    DateTime? loggedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        loggedAt = loggedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'ml': ml,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        id: json['id'] as String,
        ml: (json['ml'] as num).toDouble(),
        loggedAt: DateTime.parse(json['loggedAt'] as String),
      );
}
