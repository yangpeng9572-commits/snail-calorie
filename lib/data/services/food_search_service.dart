import '../models/food_item.dart';
import 'open_food_facts_service.dart';
import 'taiwanese_food_database.dart';

/// 合併食物搜尋服務
/// 優先搜尋本地台灣食物資料庫，失敗時才呼叫 Open Food Facts API
class FoodSearchService {
  final OpenFoodFactsService _apiService;

  FoodSearchService({OpenFoodFactsService? apiService})
      : _apiService = apiService ?? OpenFoodFactsService();

  /// 搜尋食物（本地優先 + API fallback）
  /// [query] 搜尋關鍵字
  /// [limit] 最多回傳數量
  /// 回傳 [localResults, apiResults] 兩組結果
  Future<FoodSearchResult> searchFoods(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) {
      return FoodSearchResult.empty();
    }

    // Step 1: 先搜本地資料庫
    final localResults = TaiwaneseFoodDatabase.search(query);

    // Step 2: 如果本地結果不夠，呼叫 API
    List<FoodItem> apiResults = [];
    if (localResults.length < limit) {
      try {
        apiResults = await _apiService.searchFoods(query);
        // 過濾掉與本地重複的（以名稱相似度判斷）
        final localNames = localResults.map((f) => f.name).toSet();
        apiResults = apiResults
            .where((f) => !localNames.any((name) =>
                _similarEnough(name, f.name) ||
                _similarEnough(f.name, name)))
            .toList();
      } catch (_) {
        // API 失敗就只用本地結果
        apiResults = [];
      }
    }

    return FoodSearchResult(
      localFoods: localResults,
      apiFoods: apiResults.take(limit - localResults.length).toList(),
    );
  }

  /// 以條碼查詢
  Future<FoodItem?> getFoodByBarcode(String barcode) async {
    if (barcode.isEmpty) return null;

    // 先查本地（一般包裝食品條碼可能不在本地資料庫）
    final localResults = TaiwaneseFoodDatabase.search(barcode);
    if (localResults.isNotEmpty) {
      return localResults.first;
    }

    // 查 API
    return _apiService.getFoodByBarcode(barcode);
  }

  /// 簡單的字串相似度判斷（用於過濾重複）
  bool _similarEnough(String a, String b) {
    if (a.isEmpty || b.isEmpty) return false;
    // 檢查是否一個字串被另一個完全包含（忽略括號和品牌）
    final cleanA = a.replaceAll(RegExp(r'[\（\(].*?[\）\)]'), '').trim();
    final cleanB = b.replaceAll(RegExp(r'[\（\(].*?[\）\)]'), '').trim();
    return cleanA.length > 3 &&
        (cleanA.contains(cleanB) || cleanB.contains(cleanA));
  }
}

/// 搜尋結果封裝
class FoodSearchResult {
  final List<FoodItem> localFoods;
  final List<FoodItem> apiFoods;

  FoodSearchResult({required this.localFoods, required this.apiFoods});

  factory FoodSearchResult.empty() => FoodSearchResult(localFoods: [], apiFoods: []);

  List<FoodItem> get all => [...localFoods, ...apiFoods];

  bool get isEmpty => localFoods.isEmpty && apiFoods.isEmpty;

  int get totalCount => localFoods.length + apiFoods.length;
}
