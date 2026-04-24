class FoodItem {
  final String id;
  final String name;
  final String? brand;
  final double calories; // per 100g
  final double carbs; // per 100g
  final double protein; // per 100g
  final double fat; // per 100g
  final double servingSize; // default serving in grams
  final String? barcode;
  final String? imageUrl;

  const FoodItem({
    required this.id,
    required this.name,
    this.brand,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.servingSize = 100,
    this.barcode,
    this.imageUrl,
  });

  /// 工廠：從 Open Food Facts API 回應建立
  factory FoodItem.fromOpenFoodFacts(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? json;
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    // 解析營養素（可能為字串或數字）
    double parseNutrient(dynamic value, [double defaultVal = 0]) {
      if (value == null) return defaultVal;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultVal;
      return defaultVal;
    }

    return FoodItem(
      id: '${product['code'] ?? product['_id'] ?? ''}',
      name: product['product_name'] as String? ??
            product['product_name_tw'] as String? ??
            product['brands'] as String? ?? '未知食物',
      brand: product['brands'] as String?,
      calories: parseNutrient(nutriments['energy-kcal_100g'], 0),
      carbs: parseNutrient(nutriments['carbohydrates_100g'], 0),
      protein: parseNutrient(nutriments['proteins_100g'], 0),
      fat: parseNutrient(nutriments['fat_100g'], 0),
      servingSize: parseNutrient(product['serving_size']),
      barcode: product['code'] as String?,
      imageUrl: product['image_small_url'] as String? ??
                product['image_url'] as String?,
    );
  }

  /// 根據份量計算熱量
  double caloriesForServing(double grams) => (calories / 100) * grams;
  double carbsForServing(double grams) => (carbs / 100) * grams;
  double proteinForServing(double grams) => (protein / 100) * grams;
  double fatForServing(double grams) => (fat / 100) * grams;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'calories': calories,
    'carbs': carbs,
    'protein': protein,
    'fat': fat,
    'servingSize': servingSize,
    'barcode': barcode,
    'imageUrl': imageUrl,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'] as String,
    name: json['name'] as String,
    brand: json['brand'] as String?,
    calories: (json['calories'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    protein: (json['protein'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
    servingSize: (json['servingSize'] as num?)?.toDouble() ?? 100,
    barcode: json['barcode'] as String?,
    imageUrl: json['imageUrl'] as String?,
  );

  @override
  String toString() => '$name (${brand ?? '一般'}) - ${calories}kcal/100g';
}
