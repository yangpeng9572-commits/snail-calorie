import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/recipe_models.dart';
import '../../data/services/gemini_recipe_generation_service.dart';
import '../../core/config/api_keys.dart';
import '../../core/theme/app_theme.dart';

/// 清冰箱食譜生成頁面
/// 
/// 使用 Gemini 1.5 Flash API，根據用戶選擇的食材生成食譜
/// 
/// 使用方式：
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => FridgeRecipePage(apiKey: 'YOUR_API_KEY'),
///   ),
/// );
/// ```
class FridgeRecipePage extends StatefulWidget {
  const FridgeRecipePage({super.key});

  @override
  State<FridgeRecipePage> createState() => _FridgeRecipePageState();
}

class _FridgeRecipePageState extends State<FridgeRecipePage> {
  late final GeminiRecipeGenerationService _recipeService;
  
  // 選中的食材
  final List<String> _selectedIngredients = [];
  
  // 生成的食譜
  GeneratedRecipe? _generatedRecipe;
  
  // 載入狀態
  bool _isLoading = false;
  
  // 錯誤訊息
  String? _errorMessage;
  
  // 文字輸入控制器
  final TextEditingController _ingredientController = TextEditingController();
  
  // 常見食材快速新增
  static const List<String> _quickAddIngredients = [
    '雞蛋',
    '番茄',
    '蔥',
    '蒜',
    '洋蔥',
    '青菜',
    '豆腐',
    '豬肉',
    '雞肉',
    '魚',
    '蝦',
    '米飯',
    '麵條',
    '豆腐',
    '香菇',
    '紅蘿蔔',
  ];

  @override
  void initState() {
    super.initState();
    _recipeService = GeminiRecipeGenerationService(apiKey: ApiKeys.geminiApiKey);
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _recipeService.dispose();
    super.dispose();
  }

  /// 新增食材
  void _addIngredient(String ingredient) {
    final trimmed = ingredient.trim();
    if (trimmed.isNotEmpty && !_selectedIngredients.contains(trimmed)) {
      setState(() {
        _selectedIngredients.add(trimmed);
        _errorMessage = null;
      });
      _ingredientController.clear();
    }
  }

  /// 移除食材
  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  /// 生成食譜
  Future<void> _generateRecipe() async {
    if (_selectedIngredients.isEmpty) {
      setState(() {
        _errorMessage = '請至少選擇一種食材';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _generatedRecipe = null;
    });

    try {
      final recipe = await _recipeService.generateRecipe(_selectedIngredients);
      setState(() {
        _generatedRecipe = recipe;
        _isLoading = false;
        if (recipe == null) {
          _errorMessage = '無法生成食譜，請稍後再試';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '生成食譜時發生錯誤：${e.toString()}';
      });
    }
  }

  /// 清除所有
  void _clearAll() {
    setState(() {
      _selectedIngredients.clear();
      _generatedRecipe = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('清冰箱食譜'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_selectedIngredients.isNotEmpty || _generatedRecipe != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _clearAll,
              tooltip: '清除所有',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 食材輸入區
            _buildIngredientInputSection(),
            const SizedBox(height: 16),
            
            // 已選食材顯示
            if (_selectedIngredients.isNotEmpty) ...[
              _buildSelectedIngredientsSection(),
              const SizedBox(height: 24),
            ],
            
            // 快速新增區
            _buildQuickAddSection(),
            const SizedBox(height: 24),
            
            // 錯誤訊息
            if (_errorMessage != null) ...[
              _buildErrorMessage(),
              const SizedBox(height: 16),
            ],
            
            // 生成按鈕
            _buildGenerateButton(),
            const SizedBox(height: 24),
            
            // 生成的食譜
            if (_generatedRecipe != null) ...[
              _buildRecipeSection(),
            ],
            
            // 載入中
            if (_isLoading) ...[
              _buildLoadingIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  /// 食材輸入區
  Widget _buildIngredientInputSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '新增食材',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: const InputDecoration(
                      hintText: '輸入食材名稱',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _addIngredient,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _addIngredient(_ingredientController.text),
                  icon: const Icon(Icons.add),
                  label: const Text('新增'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 已選食材顯示區
  Widget _buildSelectedIngredientsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '已選食材 (${_selectedIngredients.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Text('清除全部'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedIngredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeIngredient(ingredient),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 快速新增區
  Widget _buildQuickAddSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快速新增',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAddIngredients
                  .where((ingredient) => !_selectedIngredients.contains(ingredient))
                  .take(12)
                  .map((ingredient) {
                return ActionChip(
                  label: Text(ingredient),
                  onPressed: () => _addIngredient(ingredient),
                  avatar: const Icon(Icons.add, size: 16),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 錯誤訊息
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 生成按鈕
  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _generateRecipe,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.restaurant_menu),
        label: Text(
          _isLoading ? '生成中...' : '生成食譜',
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  /// 載入中指示器
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在使用 AI 生成食譜...'),
            SizedBox(height: 8),
            Text(
              '請稍候',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// 食譜顯示區
  Widget _buildRecipeSection() {
    final recipe = _generatedRecipe!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 食譜標題卡片
        Card(
          elevation: 4,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restaurant_menu, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recipe.recipeName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                if (recipe.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 16,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // 食譜資訊標籤
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      Icons.timer,
                      '${recipe.prepTimeMinutes + recipe.cookTimeMinutes}分鐘',
                    ),
                    _buildInfoChip(
                      Icons.restaurant,
                      '${recipe.servings}人份',
                    ),
                    _buildDifficultyChip(recipe.difficulty),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 食材列表
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_basket),
                    const SizedBox(width: 8),
                    Text(
                      '食材',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${recipe.ingredients.length}項',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(),
                ...recipe.ingredients.map((ingredient) {
                  final isFromFridge = ingredient.isFromFridge;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isFromFridge ? Icons.kitchen : Icons.shopping_cart,
                          size: 20,
                          color: isFromFridge 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: TextStyle(
                              fontWeight: isFromFridge ? FontWeight.w500 : null,
                            ),
                          ),
                        ),
                        Text(
                          '${ingredient.amount} ${ingredient.unit}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 步驟說明
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.format_list_numbered),
                    const SizedBox(width: 8),
                    Text(
                      '步驟',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ...recipe.instructions.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 營養資訊
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pie_chart),
                    const SizedBox(width: 8),
                    Text(
                      '營養資訊（每份）',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutritionItem(
                      '熱量',
                      '${recipe.nutritionPerServing.calories.toStringAsFixed(0)}',
                      'kcal',
                      Colors.orange,
                    ),
                    _buildNutritionItem(
                      '蛋白質',
                      '${recipe.nutritionPerServing.proteinG.toStringAsFixed(1)}',
                      'g',
                      Colors.red,
                    ),
                    _buildNutritionItem(
                      '碳水',
                      '${recipe.nutritionPerServing.carbsG.toStringAsFixed(1)}',
                      'g',
                      Colors.blue,
                    ),
                    _buildNutritionItem(
                      '脂肪',
                      '${recipe.nutritionPerServing.fatG.toStringAsFixed(1)}',
                      'g',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // 標籤
        if (recipe.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.label),
                      const SizedBox(width: 8),
                      Text(
                        '標籤',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
        
        const SizedBox(height: 32),
      ],
    );
  }

  /// 資訊標籤
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  /// 難度標籤
  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    String label;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        label = '簡單';
        break;
      case 'medium':
        color = Colors.orange;
        label = '中等';
        break;
      case 'hard':
        color = Colors.red;
        label = '困難';
        break;
      default:
        color = Colors.grey;
        label = difficulty;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.signal_cellular_alt, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }

  /// 營養項目
  Widget _buildNutritionItem(
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
