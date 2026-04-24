import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';
import '../../core/constants/app_constants.dart';

/// Open Food Facts API 服務
class OpenFoodFactsService {
  static const String _baseUrl = AppConstants.openFoodFactsBaseUrl;
  final http.Client _client;

  OpenFoodFactsService({http.Client? client}) : _client = client ?? http.Client();

  /// 搜尋食物
  Future<List<FoodItem>> searchFoods(String query, {int page = 1, int pageSize = 20}) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse('$_baseUrl/cgi/search.pl').replace(
        queryParameters: {
          'search_terms': query,
          'search_simple': '1',
          'action': 'process',
          'json': '1',
          'page': page.toString(),
          'page_size': pageSize.toString(),
          'fields': 'code,product_name,product_name_tw,brands,nutriments,serving_size,image_small_url,image_url',
        },
      );

      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final products = data['products'] as List? ?? [];

      return products
          .where((p) => p['product_name'] != null || p['product_name_tw'] != null)
          .map((p) => FoodItem.fromOpenFoodFacts(p as Map<String, dynamic>))
          .where((f) => f.calories > 0 || f.carbs > 0 || f.protein > 0 || f.fat > 0)
          .toList();
    } catch (e) {
      // 回傳空陣列而非拋出錯誤，搜尋失敗時不會整個 App 壞掉
      return [];
    }
  }

  /// 以條碼查詢食品
  Future<FoodItem?> getFoodByBarcode(String barcode) async {
    if (barcode.isEmpty) return null;

    try {
      final uri = Uri.parse('$_baseUrl/api/v0/product/$barcode.json');
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 1) return null;

      return FoodItem.fromOpenFoodFacts(data);
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
