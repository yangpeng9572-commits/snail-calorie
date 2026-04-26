class AppLocalizations {
  final String languageCode; // 'zh' or 'en'
  AppLocalizations(this.languageCode);

  static final zh = AppLocalizations('zh');
  static final en = AppLocalizations('en');

  String get appName => languageCode == 'zh' ? '食刻輕卡' : 'Snail Calorie';
  String get home => languageCode == 'zh' ? '首頁' : 'Home';
  String get search => languageCode == 'zh' ? '搜尋' : 'Search';
  String get profile => languageCode == 'zh' ? '設定' : 'Profile';
  String get calories => languageCode == 'zh' ? '熱量' : 'Calories';
  String get protein => languageCode == 'zh' ? '蛋白質' : 'Protein';
  String get carbs => languageCode == 'zh' ? '碳水化合物' : 'Carbs';
  String get fat => languageCode == 'zh' ? '脂肪' : 'Fat';
  String get breakfast => languageCode == 'zh' ? '早餐' : 'Breakfast';
  String get lunch => languageCode == 'zh' ? '午餐' : 'Lunch';
  String get dinner => languageCode == 'zh' ? '晚餐' : 'Dinner';
  String get snack => languageCode == 'zh' ? '點心' : 'Snack';
  String get addFood => languageCode == 'zh' ? '加入食物' : 'Add Food';
  String get searchHint => languageCode == 'zh' ? '搜尋食物名稱...' : 'Search food name...';
  String get noResults => languageCode == 'zh' ? '找不到食物，試著換個關鍵字' : 'No results found, try another keyword';
  String get overTarget => languageCode == 'zh' ? '今日熱量已超標' : 'Over daily target';
  String get remaining => languageCode == 'zh' ? '剩餘' : 'Remaining';
}
