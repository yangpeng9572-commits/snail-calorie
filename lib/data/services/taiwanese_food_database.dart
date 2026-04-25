import '../models/food_item.dart';

/// 台灣本地食物資料庫（離線可用）
/// 收錄 40+ 熱門台灣美食，營養數據以每100g為基準
class TaiwaneseFoodDatabase {
  static final List<FoodItem> _foods = [
    // ===== 早餐類 =====
    const FoodItem(
      id: 'tw_001', name: '蚵仔麵線', brand: '傳統小吃',
      calories: 97, protein: 3.5, carbs: 14.0, fat: 2.8,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_002', name: '蛋餅', brand: '傳統早餐',
      calories: 180, protein: 6.0, carbs: 22.0, fat: 7.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_003', name: '蘿蔔糕', brand: '傳統早餐',
      calories: 130, protein: 2.5, carbs: 25.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_004', name: '小籠包', brand: '傳統小吃',
      calories: 250, protein: 10.0, carbs: 25.0, fat: 11.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_005', name: '燒餅油條', brand: '傳統早餐',
      calories: 290, protein: 8.0, carbs: 35.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_006', name: '飯糰', brand: '傳統早餐',
      calories: 210, protein: 5.0, carbs: 38.0, fat: 4.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_007', name: '蛋餅（含鮪魚）', brand: '傳統早餐',
      calories: 210, protein: 10.0, carbs: 20.0, fat: 9.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),

    // ===== 飲料類 =====
    const FoodItem(
      id: 'tw_101', name: '珍珠奶茶', brand: '手搖飲',
      calories: 78, protein: 1.2, carbs: 13.0, fat: 2.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_102', name: '波霸奶茶', brand: '手搖飲',
      calories: 75, protein: 1.0, carbs: 12.5, fat: 2.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_103', name: '冬瓜茶', brand: '手搖飲',
      calories: 30, protein: 0.0, carbs: 7.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_104', name: '檸檬愛玉', brand: '手搖飲',
      calories: 25, protein: 0.0, carbs: 6.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_105', name: '豆漿（無糖）', brand: '早餐店',
      calories: 33, protein: 3.0, carbs: 2.0, fat: 1.3,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_106', name: '米漿', brand: '早餐店',
      calories: 55, protein: 1.2, carbs: 10.0, fat: 1.2,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_107', name: '鮮奶茶', brand: '手搖飲',
      calories: 55, protein: 2.0, carbs: 6.0, fat: 2.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_108', name: '青茶（無糖）', brand: '手搖飲',
      calories: 5, protein: 0.0, carbs: 1.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_109', name: '百香果綠茶', brand: '手搖飲',
      calories: 42, protein: 0.1, carbs: 10.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),

    // ===== 便當類 =====
    const FoodItem(
      id: 'tw_201', name: '雞腿便當', brand: '便當店',
      calories: 680, protein: 32.0, carbs: 65.0, fat: 28.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_202', name: '排骨便當', brand: '便當店',
      calories: 720, protein: 30.0, carbs: 75.0, fat: 30.0,
      servingSize: 750, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_203', name: '控肉便當', brand: '便當店',
      calories: 750, protein: 28.0, carbs: 70.0, fat: 35.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_204', name: '滷肉飯', brand: '小吃店',
      calories: 290, protein: 9.0, carbs: 45.0, fat: 9.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_205', name: '焢肉飯', brand: '小吃店',
      calories: 350, protein: 12.0, carbs: 48.0, fat: 12.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),

    // ===== 麵食類 =====
    const FoodItem(
      id: 'tw_301', name: '牛肉麵', brand: '小吃店',
      calories: 215, protein: 14.0, carbs: 22.0, fat: 8.0,
      servingSize: 600, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_302', name: '担仔麵', brand: '小吃店',
      calories: 180, protein: 10.0, carbs: 20.0, fat: 6.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_303', name: '陽春麵', brand: '小吃店',
      calories: 150, protein: 5.0, carbs: 25.0, fat: 3.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_304', name: '炸醬麵', brand: '小吃店',
      calories: 200, protein: 7.0, carbs: 28.0, fat: 6.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_305', name: '麻醬麵', brand: '小吃店',
      calories: 320, protein: 8.0, carbs: 30.0, fat: 18.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),

    // ===== 小吃類 =====
    const FoodItem(
      id: 'tw_401', name: '大腸包小腸', brand: '夜市小吃',
      calories: 320, protein: 12.0, carbs: 30.0, fat: 17.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_402', name: '蚵仔煎', brand: '夜市小吃',
      calories: 225, protein: 10.0, carbs: 22.0, fat: 11.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_403', name: '鹹酥雞', brand: '鹹酥雞攤',
      calories: 290, protein: 18.0, carbs: 12.0, fat: 18.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_404', name: '炸雞排', brand: '鹹酥雞攤',
      calories: 270, protein: 17.0, carbs: 12.0, fat: 17.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_405', name: '雞翅（炸）', brand: '鹹酥雞攤',
      calories: 230, protein: 19.0, carbs: 8.0, fat: 14.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_406', name: '臭豆腐', brand: '夜市小吃',
      calories: 150, protein: 8.0, carbs: 10.0, fat: 9.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_407', name: '肉圓', brand: '小吃店',
      calories: 200, protein: 6.0, carbs: 28.0, fat: 7.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_408', name: '碗粿', brand: '小吃店',
      calories: 130, protein: 3.0, carbs: 24.0, fat: 2.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_409', name: '筒仔米糕', brand: '小吃店',
      calories: 180, protein: 4.0, carbs: 30.0, fat: 4.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),

    // ===== 甜點類 =====
    const FoodItem(
      id: 'tw_501', name: '豆花', brand: '甜品店',
      calories: 95, protein: 3.0, carbs: 16.0, fat: 1.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_502', name: '珍珠豆花', brand: '甜品店',
      calories: 110, protein: 3.0, carbs: 21.0, fat: 1.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_503', name: '挫冰（配料）', brand: '冰店',
      calories: 100, protein: 1.0, carbs: 22.0, fat: 0.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_504', name: '芒果冰', brand: '冰店',
      calories: 120, protein: 1.0, carbs: 27.0, fat: 0.5,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_505', name: '燒仙草', brand: '甜品店',
      calories: 80, protein: 1.0, carbs: 18.0, fat: 0.3,
      servingSize: 300, barcode: null, imageUrl: null,
    ),

    // ===== 鍋貼/水餃類 =====
    const FoodItem(
      id: 'tw_601', name: '鍋貼', brand: '小吃店',
      calories: 230, protein: 9.0, carbs: 22.0, fat: 12.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_602', name: '水餃', brand: '小吃店',
      calories: 200, protein: 10.0, carbs: 22.0, fat: 8.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_603', name: '蒸餃', brand: '小吃店',
      calories: 180, protein: 9.0, carbs: 20.0, fat: 7.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_604', name: '餛飩湯', brand: '小吃店',
      calories: 150, protein: 8.0, carbs: 18.0, fat: 5.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),

    // ===== 湯類 =====
    const FoodItem(
      id: 'tw_701', name: '貢丸湯', brand: '小吃店',
      calories: 70, protein: 8.0, carbs: 4.0, fat: 3.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_702', name: '蛋花湯', brand: '小吃店',
      calories: 35, protein: 2.5, carbs: 2.0, fat: 1.8,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_703', name: '酸辣湯', brand: '小吃店',
      calories: 60, protein: 2.0, carbs: 8.0, fat: 2.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),

    // ===== 素食類 =====
    const FoodItem(
      id: 'tw_801', name: '滷味（素）', brand: '滷味攤',
      calories: 130, protein: 5.0, carbs: 15.0, fat: 5.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_802', name: '素食便當', brand: '便當店',
      calories: 550, protein: 15.0, carbs: 75.0, fat: 18.0,
      servingSize: 650, barcode: null, imageUrl: null,
    ),
  ];

  /// 搜尋食物（模糊比對）
  static List<FoodItem> search(String query) {
    if (query.trim().isEmpty) return [];
    final lower = query.toLowerCase();
    return _foods.where((f) {
      return f.name.toLowerCase().contains(lower) ||
          (f.brand?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  /// 取得所有食物
  static List<FoodItem> getAll() => List.unmodifiable(_foods);

  /// 取得熱門食物（前12樣）
  static List<FoodItem> getPopular() {
    return [
      _foods.firstWhere((f) => f.id == 'tw_101'), // 珍珠奶茶
      _foods.firstWhere((f) => f.id == 'tw_201'), // 雞腿便當
      _foods.firstWhere((f) => f.id == 'tw_204'), // 滷肉飯
      _foods.firstWhere((f) => f.id == 'tw_301'), // 牛肉麵
      _foods.firstWhere((f) => f.id == 'tw_403'), // 鹹酥雞
      _foods.firstWhere((f) => f.id == 'tw_004'), // 小籠包
      _foods.firstWhere((f) => f.id == 'tw_501'), // 豆花
      _foods.firstWhere((f) => f.id == 'tw_402'), // 蚵仔煎
      _foods.firstWhere((f) => f.id == 'tw_602'), // 水餃
      _foods.firstWhere((f) => f.id == 'tw_202'), // 排骨便當
      _foods.firstWhere((f) => f.id == 'tw_102'), // 波霸奶茶
      _foods.firstWhere((f) => f.id == 'tw_702'), // 蛋花湯
    ];
  }
}
