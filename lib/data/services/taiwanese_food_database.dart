import '../models/food_item.dart';

/// 台灣本地食物資料庫（離線可用）
/// 收錄 500 項熱門台灣美食，營養數據以每100g為基準
class TaiwaneseFoodDatabase {
  static final List<FoodItem> _foods = [
    // ===== 早餐類 (40項) =====
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
    const FoodItem(
      id: 'tw_008', name: '韭菜盒', brand: '傳統早餐',
      calories: 220, protein: 5.5, carbs: 28.0, fat: 10.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_009', name: '水煎包', brand: '傳統早餐',
      calories: 230, protein: 7.0, carbs: 25.0, fat: 11.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_010', name: '饅頭夾蛋', brand: '傳統早餐',
      calories: 240, protein: 9.0, carbs: 30.0, fat: 9.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_011', name: '花生厚片', brand: '早餐店',
      calories: 280, protein: 5.0, carbs: 35.0, fat: 14.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_012', name: '火腿蛋餅', brand: '傳統早餐',
      calories: 195, protein: 7.5, carbs: 23.0, fat: 8.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_013', name: '玉米蛋餅', brand: '傳統早餐',
      calories: 185, protein: 6.0, carbs: 24.0, fat: 7.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_014', name: '肉鬆蛋餅', brand: '傳統早餐',
      calories: 200, protein: 8.0, carbs: 24.0, fat: 8.0,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_015', name: '鐵板麵（加蛋）', brand: '早餐店',
      calories: 350, protein: 12.0, carbs: 40.0, fat: 16.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_016', name: '蘿蔔絲餅', brand: '傳統早餐',
      calories: 210, protein: 4.0, carbs: 27.0, fat: 9.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_017', name: '葱油餅', brand: '傳統早餐',
      calories: 250, protein: 5.0, carbs: 30.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_018', name: '蛋塔', brand: '麵包店',
      calories: 280, protein: 4.5, carbs: 32.0, fat: 15.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_019', name: '烤吐司（奶油）', brand: '早餐店',
      calories: 275, protein: 6.0, carbs: 35.0, fat: 12.5,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_020', name: '法式吐司', brand: '早餐店',
      calories: 290, protein: 8.0, carbs: 30.0, fat: 15.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    // ===== 早餐類-新增 (20項) tw_021-040 =====
    const FoodItem(
      id: 'tw_021', name: '三明治（火腿起司）', brand: '早餐店',
      calories: 210, protein: 8.0, carbs: 25.0, fat: 9.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_022', name: '鮪魚蛋餅', brand: '早餐店',
      calories: 215, protein: 11.0, carbs: 22.0, fat: 10.0,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_023', name: '薯餅蛋餅', brand: '早餐店',
      calories: 230, protein: 7.0, carbs: 28.0, fat: 11.0,
      servingSize: 140, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_024', name: '泡菜蛋餅', brand: '早餐店',
      calories: 195, protein: 6.5, carbs: 23.0, fat: 8.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_025', name: '肉蛋吐司', brand: '早餐店',
      calories: 280, protein: 11.0, carbs: 30.0, fat: 13.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_026', name: '豬排蛋吐司', brand: '早餐店',
      calories: 320, protein: 14.0, carbs: 30.0, fat: 16.0,
      servingSize: 140, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_027', name: '煎蛋吐司', brand: '早餐店',
      calories: 250, protein: 8.0, carbs: 28.0, fat: 12.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_028', name: '草莓吐司', brand: '早餐店',
      calories: 230, protein: 4.5, carbs: 38.0, fat: 7.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_029', name: '奶酥吐司', brand: '早餐店',
      calories: 260, protein: 5.0, carbs: 32.0, fat: 13.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_030', name: '花生吐司', brand: '早餐店',
      calories: 250, protein: 6.0, carbs: 30.0, fat: 12.5,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_031', name: '肉鬆吐司', brand: '早餐店',
      calories: 245, protein: 9.0, carbs: 30.0, fat: 10.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_032', name: '鍋鏟吐司', brand: '早餐店',
      calories: 270, protein: 8.5, carbs: 32.0, fat: 13.0,
      servingSize: 110, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_033', name: '沙拉吐司', brand: '早餐店',
      calories: 220, protein: 5.0, carbs: 28.0, fat: 10.5,
      servingSize: 90, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_034', name: '玉米濃湯', brand: '早餐店',
      calories: 80, protein: 2.0, carbs: 10.0, fat: 3.5,
      servingSize: 240, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_035', name: '火腿蛋三明治', brand: '早餐店',
      calories: 230, protein: 10.0, carbs: 25.0, fat: 11.0,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_036', name: '雞蛋沙拉三明治', brand: '早餐店',
      calories: 210, protein: 7.0, carbs: 24.0, fat: 10.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_037', name: '馬鈴薯煎餅', brand: '早餐店',
      calories: 180, protein: 3.5, carbs: 25.0, fat: 7.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_038', name: '地瓜煎餅', brand: '早餐店',
      calories: 165, protein: 2.5, carbs: 30.0, fat: 4.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_039', name: '九層塔蛋餅', brand: '早餐店',
      calories: 200, protein: 7.5, carbs: 22.0, fat: 9.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_040', name: '蝦皮蛋餅', brand: '早餐店',
      calories: 205, protein: 8.0, carbs: 22.0, fat: 9.5,
      servingSize: 130, barcode: null, imageUrl: null,
    ),

    // ===== 便當/主食類 (60項) =====
    const FoodItem(
      id: 'tw_101', name: '雞腿便當', brand: '便當店',
      calories: 680, protein: 32.0, carbs: 65.0, fat: 28.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_102', name: '排骨便當', brand: '便當店',
      calories: 720, protein: 30.0, carbs: 75.0, fat: 30.0,
      servingSize: 750, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_103', name: '控肉便當', brand: '便當店',
      calories: 750, protein: 28.0, carbs: 70.0, fat: 35.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_104', name: '滷肉飯', brand: '小吃店',
      calories: 290, protein: 9.0, carbs: 45.0, fat: 9.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_105', name: '焢肉飯', brand: '小吃店',
      calories: 350, protein: 12.0, carbs: 48.0, fat: 12.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_106', name: '牛肉麵', brand: '小吃店',
      calories: 215, protein: 14.0, carbs: 22.0, fat: 8.0,
      servingSize: 600, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_107', name: '担仔麵', brand: '小吃店',
      calories: 180, protein: 10.0, carbs: 20.0, fat: 6.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_108', name: '陽春麵', brand: '小吃店',
      calories: 150, protein: 5.0, carbs: 25.0, fat: 3.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_109', name: '炸醬麵', brand: '小吃店',
      calories: 200, protein: 7.0, carbs: 28.0, fat: 6.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_110', name: '麻醬麵', brand: '小吃店',
      calories: 320, protein: 8.0, carbs: 30.0, fat: 18.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_111', name: '素食便當', brand: '便當店',
      calories: 550, protein: 15.0, carbs: 75.0, fat: 18.0,
      servingSize: 650, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_112', name: '魚排便當', brand: '便當店',
      calories: 580, protein: 28.0, carbs: 65.0, fat: 22.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_113', name: '爌肉飯', brand: '小吃店',
      calories: 340, protein: 14.0, carbs: 42.0, fat: 13.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_114', name: '雞肉飯', brand: '小吃店',
      calories: 280, protein: 14.0, carbs: 38.0, fat: 8.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_115', name: '陽春湯麵', brand: '小吃店',
      calories: 165, protein: 6.0, carbs: 26.0, fat: 4.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_116', name: '榨菜肉絲麵', brand: '小吃店',
      calories: 190, protein: 10.0, carbs: 24.0, fat: 6.5,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_117', name: '餛飩麵', brand: '小吃店',
      calories: 200, protein: 9.0, carbs: 25.0, fat: 7.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_118', name: '刀削麵', brand: '小吃店',
      calories: 180, protein: 6.0, carbs: 28.0, fat: 5.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_119', name: '海鮮炒麵', brand: '小吃店',
      calories: 230, protein: 12.0, carbs: 28.0, fat: 9.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_120', name: '蚵仔炒麵', brand: '小吃店',
      calories: 210, protein: 11.0, carbs: 25.0, fat: 8.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    // ===== 便當/主食類-新增 (40項) tw_121-160 =====
    const FoodItem(
      id: 'tw_121', name: '雞排便當', brand: '便當店',
      calories: 650, protein: 30.0, carbs: 68.0, fat: 25.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_122', name: '炸魚便當', brand: '便當店',
      calories: 600, protein: 26.0, carbs: 65.0, fat: 24.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_123', name: '紅燒牛肉麵', brand: '小吃店',
      calories: 280, protein: 18.0, carbs: 28.0, fat: 10.0,
      servingSize: 550, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_124', name: '番茄牛肉麵', brand: '小吃店',
      calories: 260, protein: 16.0, carbs: 30.0, fat: 9.0,
      servingSize: 550, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_125', name: '酸菜白肉鍋', brand: '小吃店',
      calories: 180, protein: 15.0, carbs: 12.0, fat: 9.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_126', name: '羊肉爐', brand: '小吃店',
      calories: 220, protein: 20.0, carbs: 10.0, fat: 12.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_127', name: '薑母鴨', brand: '小吃店',
      calories: 190, protein: 18.0, carbs: 8.0, fat: 10.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_128', name: '砂鍋魚頭', brand: '小吃店',
      calories: 230, protein: 22.0, carbs: 10.0, fat: 12.0,
      servingSize: 450, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_129', name: '蚵仔麵線（大腸）', brand: '小吃店',
      calories: 200, protein: 6.0, carbs: 28.0, fat: 6.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_130', name: '蚵仔麵線（加蛋）', brand: '小吃店',
      calories: 215, protein: 9.0, carbs: 26.0, fat: 8.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_131', name: '福州麵', brand: '小吃店',
      calories: 190, protein: 6.0, carbs: 28.0, fat: 6.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_132', name: '傻瓜麵', brand: '小吃店',
      calories: 180, protein: 5.0, carbs: 30.0, fat: 4.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_133', name: '意麵', brand: '小吃店',
      calories: 170, protein: 5.0, carbs: 28.0, fat: 4.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_134', name: '大卤麵', brand: '小吃店',
      calories: 195, protein: 7.0, carbs: 26.0, fat: 6.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_135', name: '榨菜肉絲飯', brand: '小吃店',
      calories: 260, protein: 12.0, carbs: 35.0, fat: 8.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_136', name: '肉燥飯', brand: '小吃店',
      calories: 270, protein: 10.0, carbs: 38.0, fat: 9.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_137', name: '雞肉飯（嘉義）', brand: '小吃店',
      calories: 300, protein: 15.0, carbs: 38.0, fat: 9.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_138', name: '鱔魚麵', brand: '小吃店',
      calories: 200, protein: 14.0, carbs: 22.0, fat: 7.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_139', name: '花枝麵', brand: '小吃店',
      calories: 190, protein: 12.0, carbs: 24.0, fat: 7.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_140', name: '蛤蜊麵', brand: '小吃店',
      calories: 175, protein: 11.0, carbs: 22.0, fat: 6.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_141', name: '臭豆腐（麻辣）', brand: '小吃店',
      calories: 180, protein: 9.0, carbs: 12.0, fat: 11.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_142', name: '素燥飯', brand: '小吃店',
      calories: 240, protein: 6.0, carbs: 40.0, fat: 6.0,
      servingSize: 280, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_143', name: '素食炒麵', brand: '小吃店',
      calories: 200, protein: 5.0, carbs: 32.0, fat: 6.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_144', name: '八寶飯', brand: '小吃店',
      calories: 260, protein: 6.0, carbs: 45.0, fat: 6.5,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_145', name: '油飯', brand: '小吃店',
      calories: 220, protein: 5.0, carbs: 35.0, fat: 7.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_146', name: '米苔目', brand: '小吃店',
      calories: 150, protein: 3.0, carbs: 28.0, fat: 3.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_147', name: '粄條', brand: '小吃店',
      calories: 160, protein: 3.0, carbs: 30.0, fat: 2.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_148', name: '河粉', brand: '小吃店',
      calories: 155, protein: 3.0, carbs: 28.0, fat: 3.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_149', name: '蒸蛋', brand: '小吃店',
      calories: 100, protein: 9.0, carbs: 3.0, fat: 5.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_150', name: '茶碗蒸', brand: '小吃店',
      calories: 110, protein: 8.0, carbs: 5.0, fat: 6.0,
      servingSize: 180, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_151', name: '吻仔魚粥', brand: '小吃店',
      calories: 120, protein: 7.0, carbs: 15.0, fat: 4.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_152', name: '皮蛋瘦肉粥', brand: '小吃店',
      calories: 130, protein: 8.0, carbs: 16.0, fat: 4.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_153', name: '地瓜粥', brand: '小吃店',
      calories: 100, protein: 2.0, carbs: 20.0, fat: 1.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_154', name: '燕麥粥', brand: '小吃店',
      calories: 90, protein: 3.0, carbs: 16.0, fat: 1.5,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_155', name: '紅燒肉便當', brand: '便當店',
      calories: 680, protein: 25.0, carbs: 65.0, fat: 32.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_156', name: '香腸便當', brand: '便當店',
      calories: 720, protein: 22.0, carbs: 70.0, fat: 35.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_157', name: '滷雞腿便當', brand: '便當店',
      calories: 650, protein: 28.0, carbs: 60.0, fat: 28.0,
      servingSize: 650, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_158', name: '炸雞腿便當', brand: '便當店',
      calories: 750, protein: 30.0, carbs: 65.0, fat: 38.0,
      servingSize: 700, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_159', name: '三杯雞便當', brand: '便當店',
      calories: 620, protein: 26.0, carbs: 55.0, fat: 30.0,
      servingSize: 650, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_160', name: '麻油雞便當', brand: '便當店',
      calories: 580, protein: 24.0, carbs: 50.0, fat: 30.0,
      servingSize: 650, barcode: null, imageUrl: null,
    ),

    // ===== 小吃/夜市類 (80項) =====
    const FoodItem(
      id: 'tw_201', name: '大腸包小腸', brand: '夜市小吃',
      calories: 320, protein: 12.0, carbs: 30.0, fat: 17.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_202', name: '蚵仔煎', brand: '夜市小吃',
      calories: 225, protein: 10.0, carbs: 22.0, fat: 11.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_203', name: '鹹酥雞', brand: '鹹酥雞攤',
      calories: 290, protein: 18.0, carbs: 12.0, fat: 18.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_204', name: '炸雞排', brand: '鹹酥雞攤',
      calories: 270, protein: 17.0, carbs: 12.0, fat: 17.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_205', name: '雞翅（炸）', brand: '鹹酥雞攤',
      calories: 230, protein: 19.0, carbs: 8.0, fat: 14.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_206', name: '臭豆腐', brand: '夜市小吃',
      calories: 150, protein: 8.0, carbs: 10.0, fat: 9.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_207', name: '肉圓', brand: '小吃店',
      calories: 200, protein: 6.0, carbs: 28.0, fat: 7.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_208', name: '碗粿', brand: '小吃店',
      calories: 130, protein: 3.0, carbs: 24.0, fat: 2.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_209', name: '筒仔米糕', brand: '小吃店',
      calories: 180, protein: 4.0, carbs: 30.0, fat: 4.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_210', name: '鍋貼', brand: '小吃店',
      calories: 230, protein: 9.0, carbs: 22.0, fat: 12.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_211', name: '水餃', brand: '小吃店',
      calories: 200, protein: 10.0, carbs: 22.0, fat: 8.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_212', name: '蒸餃', brand: '小吃店',
      calories: 180, protein: 9.0, carbs: 20.0, fat: 7.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_213', name: '生煎包', brand: '小吃店',
      calories: 240, protein: 8.0, carbs: 26.0, fat: 12.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_214', name: '大腸麵線', brand: '傳統小吃',
      calories: 180, protein: 5.0, carbs: 28.0, fat: 5.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_215', name: '肉羹麵', brand: '小吃店',
      calories: 195, protein: 10.0, carbs: 24.0, fat: 7.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_216', name: '鱔魚意麵', brand: '小吃店',
      calories: 220, protein: 15.0, carbs: 22.0, fat: 9.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_217', name: '虱目魚肚', brand: '小吃店',
      calories: 200, protein: 18.0, carbs: 5.0, fat: 13.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_218', name: '旗魚黑輪', brand: '夜市小吃',
      calories: 180, protein: 10.0, carbs: 18.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_219', name: '甜不辣', brand: '夜市小吃',
      calories: 140, protein: 5.0, carbs: 20.0, fat: 4.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_220', name: '烤玉米', brand: '夜市小吃',
      calories: 145, protein: 4.0, carbs: 25.0, fat: 3.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_221', name: '滷味（葷）', brand: '滷味攤',
      calories: 180, protein: 12.0, carbs: 10.0, fat: 10.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_222', name: '炸粿', brand: '小吃店',
      calories: 200, protein: 4.0, carbs: 28.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_223', name: '蚵仔大腸麵線', brand: '傳統小吃',
      calories: 195, protein: 7.0, carbs: 26.0, fat: 6.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_224', name: '米血糕', brand: '小吃店',
      calories: 160, protein: 6.0, carbs: 22.0, fat: 5.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_225', name: '嫩豬肝', brand: '小吃店',
      calories: 140, protein: 18.0, carbs: 5.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_226', name: '炸花枝丸', brand: '夜市小吃',
      calories: 200, protein: 12.0, carbs: 15.0, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_227', name: '魷魚羹', brand: '小吃店',
      calories: 120, protein: 10.0, carbs: 12.0, fat: 4.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_228', name: '肉羹湯', brand: '小吃店',
      calories: 100, protein: 9.0, carbs: 8.0, fat: 4.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_229', name: '瓜仔肉飯', brand: '小吃店',
      calories: 300, protein: 12.0, carbs: 40.0, fat: 10.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_230', name: '滷味拼盤', brand: '滷味攤',
      calories: 190, protein: 14.0, carbs: 8.0, fat: 12.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    // ===== 小吃/夜市類-新增 (50項) tw_231-280 =====
    const FoodItem(
      id: 'tw_231', name: '炸雞翅', brand: '鹹酥雞攤',
      calories: 220, protein: 18.0, carbs: 8.0, fat: 14.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_232', name: '炸七里香', brand: '鹹酥雞攤',
      calories: 200, protein: 16.0, carbs: 6.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_233', name: '炸魷魚', brand: '夜市小吃',
      calories: 210, protein: 18.0, carbs: 10.0, fat: 12.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_234', name: '炸花枝', brand: '夜市小吃',
      calories: 190, protein: 16.0, carbs: 12.0, fat: 10.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_235', name: '炸甜不辣', brand: '夜市小吃',
      calories: 150, protein: 5.0, carbs: 22.0, fat: 5.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_236', name: '炸薯條', brand: '速食店',
      calories: 280, protein: 3.0, carbs: 35.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_237', name: '炸洋蔥圈', brand: '速食店',
      calories: 260, protein: 4.0, carbs: 30.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_238', name: '炸雞塊', brand: '速食店',
      calories: 270, protein: 14.0, carbs: 18.0, fat: 17.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_239', name: '月亮蝦餅', brand: '小吃店',
      calories: 210, protein: 12.0, carbs: 22.0, fat: 10.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_240', name: '椒麻雞', brand: '小吃店',
      calories: 250, protein: 20.0, carbs: 15.0, fat: 14.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_241', name: '打拋豬', brand: '小吃店',
      calories: 220, protein: 15.0, carbs: 10.0, fat: 14.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_242', name: '泰式酸辣麵', brand: '小吃店',
      calories: 200, protein: 8.0, carbs: 28.0, fat: 6.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_243', name: '越南河粉', brand: '小吃店',
      calories: 170, protein: 10.0, carbs: 24.0, fat: 4.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_244', name: '越南生牛肉河粉', brand: '小吃店',
      calories: 190, protein: 14.0, carbs: 22.0, fat: 5.5,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_245', name: '越南咖喱牛麵', brand: '小吃店',
      calories: 210, protein: 12.0, carbs: 26.0, fat: 8.0,
      servingSize: 380, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_246', name: '泰式炒河粉', brand: '小吃店',
      calories: 200, protein: 10.0, carbs: 28.0, fat: 6.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_247', name: '日式煎餃', brand: '小吃店',
      calories: 230, protein: 9.0, carbs: 25.0, fat: 12.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_248', name: '大阪燒', brand: '小吃店',
      calories: 200, protein: 7.0, carbs: 22.0, fat: 10.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_249', name: '章魚燒', brand: '夜市小吃',
      calories: 180, protein: 8.0, carbs: 20.0, fat: 9.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_250', name: '烤魷魚', brand: '夜市小吃',
      calories: 150, protein: 20.0, carbs: 8.0, fat: 5.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_251', name: '烤香魚', brand: '夜市小吃',
      calories: 180, protein: 18.0, carbs: 5.0, fat: 10.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_252', name: '烤吳郭魚', brand: '小吃店',
      calories: 160, protein: 20.0, carbs: 5.0, fat: 7.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_253', name: '烤秋刀魚', brand: '小吃店',
      calories: 170, protein: 16.0, carbs: 4.0, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_254', name: '烤香腸', brand: '夜市小吃',
      calories: 280, protein: 10.0, carbs: 8.0, fat: 23.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_255', name: '烤玉米（調味）', brand: '夜市小吃',
      calories: 160, protein: 4.0, carbs: 28.0, fat: 4.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_256', name: '烤麻糬', brand: '夜市小吃',
      calories: 180, protein: 3.0, carbs: 32.0, fat: 4.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_257', name: '烤年糕', brand: '小吃店',
      calories: 150, protein: 3.0, carbs: 28.0, fat: 3.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_258', name: '烤番麥', brand: '夜市小吃',
      calories: 155, protein: 4.5, carbs: 26.0, fat: 3.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_259', name: '鹽烤魚', brand: '小吃店',
      calories: 140, protein: 18.0, carbs: 4.0, fat: 6.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_260', name: '鹽烤蝦', brand: '小吃店',
      calories: 120, protein: 18.0, carbs: 3.0, fat: 4.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_261', name: '白灼蝦', brand: '小吃店',
      calories: 100, protein: 20.0, carbs: 2.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_262', name: '燙青菜', brand: '小吃店',
      calories: 50, protein: 3.0, carbs: 5.0, fat: 2.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_263', name: '炒青菜', brand: '小吃店',
      calories: 70, protein: 3.0, carbs: 6.0, fat: 4.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_264', name: '空心菜', brand: '小吃店',
      calories: 55, protein: 3.0, carbs: 5.0, fat: 2.8,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_265', name: '高麗菜', brand: '小吃店',
      calories: 45, protein: 2.0, carbs: 7.0, fat: 1.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_266', name: '地瓜葉', brand: '小吃店',
      calories: 50, protein: 3.5, carbs: 5.0, fat: 2.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_267', name: '川七', brand: '小吃店',
      calories: 45, protein: 2.0, carbs: 5.0, fat: 2.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_268', name: '過貓', brand: '小吃店',
      calories: 40, protein: 3.0, carbs: 4.0, fat: 1.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_269', name: '龍鬚菜', brand: '小吃店',
      calories: 40, protein: 3.0, carbs: 4.5, fat: 1.2,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_270', name: '山蘇', brand: '小吃店',
      calories: 45, protein: 2.5, carbs: 5.0, fat: 1.8,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_271', name: '炸跳舞菇', brand: '夜市小吃',
      calories: 160, protein: 5.0, carbs: 15.0, fat: 9.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_272', name: '炸杏鮑菇', brand: '夜市小吃',
      calories: 140, protein: 4.0, carbs: 12.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_273', name: '炸金針菇', brand: '夜市小吃',
      calories: 150, protein: 4.5, carbs: 14.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_274', name: '炸四季豆', brand: '夜市小吃',
      calories: 160, protein: 4.0, carbs: 18.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_275', name: '炸青椒', brand: '夜市小吃',
      calories: 140, protein: 3.0, carbs: 16.0, fat: 7.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_276', name: '炸茄子', brand: '夜市小吃',
      calories: 150, protein: 3.0, carbs: 15.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_277', name: '炸芋頭', brand: '夜市小吃',
      calories: 180, protein: 2.5, carbs: 30.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_278', name: '炸南瓜', brand: '夜市小吃',
      calories: 140, protein: 3.0, carbs: 20.0, fat: 5.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_279', name: '炸地瓜', brand: '夜市小吃',
      calories: 170, protein: 2.5, carbs: 28.0, fat: 5.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_280', name: '炸玉米', brand: '夜市小吃',
      calories: 165, protein: 4.0, carbs: 24.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),

    // ===== 甜點類 (20項) =====
    const FoodItem(
      id: 'tw_301', name: '豆花', brand: '甜品店',
      calories: 95, protein: 3.0, carbs: 16.0, fat: 1.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_302', name: '珍珠豆花', brand: '甜品店',
      calories: 110, protein: 3.0, carbs: 21.0, fat: 1.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_303', name: '挫冰（配料）', brand: '冰店',
      calories: 100, protein: 1.0, carbs: 22.0, fat: 0.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_304', name: '芒果冰', brand: '冰店',
      calories: 120, protein: 1.0, carbs: 27.0, fat: 0.5,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_305', name: '燒仙草', brand: '甜品店',
      calories: 80, protein: 1.0, carbs: 18.0, fat: 0.3,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_306', name: '芋圓甜湯', brand: '甜品店',
      calories: 130, protein: 2.0, carbs: 26.0, fat: 2.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_307', name: '珍珠奶茶冰', brand: '冰店',
      calories: 150, protein: 2.0, carbs: 30.0, fat: 2.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_308', name: '紅豆牛奶冰', brand: '冰店',
      calories: 135, protein: 3.0, carbs: 28.0, fat: 1.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_309', name: '花生豆花', brand: '甜品店',
      calories: 120, protein: 4.0, carbs: 20.0, fat: 2.5,
      servingSize: 280, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_310', name: '杏仁豆腐', brand: '甜品店',
      calories: 100, protein: 2.5, carbs: 15.0, fat: 2.8,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_311', name: '愛玉冰', brand: '冰店',
      calories: 55, protein: 0.5, carbs: 13.0, fat: 0.1,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_312', name: '鳳梨冰', brand: '冰店',
      calories: 90, protein: 0.5, carbs: 22.0, fat: 0.2,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_313', name: '布丁豆花', brand: '甜品店',
      calories: 115, protein: 3.5, carbs: 19.0, fat: 2.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_314', name: '綠豆薏仁湯', brand: '甜品店',
      calories: 95, protein: 3.0, carbs: 18.0, fat: 1.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_315', name: '紅豆湯', brand: '甜品店',
      calories: 110, protein: 3.5, carbs: 22.0, fat: 0.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_316', name: '花生湯', brand: '甜品店',
      calories: 130, protein: 5.0, carbs: 18.0, fat: 4.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_317', name: '芝麻湯圓', brand: '甜品店',
      calories: 180, protein: 4.0, carbs: 28.0, fat: 6.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_318', name: '芋頭牛奶冰', brand: '冰店',
      calories: 145, protein: 2.5, carbs: 28.0, fat: 2.8,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_319', name: '八寶冰', brand: '冰店',
      calories: 160, protein: 3.0, carbs: 32.0, fat: 2.0,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_320', name: '水果冰棒', brand: '冰店',
      calories: 70, protein: 0.5, carbs: 17.0, fat: 0.2,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    // ===== 甜點/冰品類-新增 (40項) tw_321-360 =====
    const FoodItem(
      id: 'tw_321', name: '冰淇淋', brand: '冰店',
      calories: 180, protein: 2.5, carbs: 22.0, fat: 9.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_322', name: '抹茶冰淇淋', brand: '冰店',
      calories: 190, protein: 3.0, carbs: 24.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_323', name: '芒果冰淇淋', brand: '冰店',
      calories: 200, protein: 2.5, carbs: 28.0, fat: 9.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_324', name: '草莓冰淇淋', brand: '冰店',
      calories: 195, protein: 2.5, carbs: 27.0, fat: 8.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_325', name: '巧克力冰淇淋', brand: '冰店',
      calories: 210, protein: 3.5, carbs: 25.0, fat: 11.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_326', name: '香草冰淇淋', brand: '冰店',
      calories: 200, protein: 3.0, carbs: 24.0, fat: 10.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_327', name: '提拉米蘇', brand: '甜品店',
      calories: 250, protein: 5.0, carbs: 28.0, fat: 13.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_328', name: '奶酪', brand: '甜品店',
      calories: 120, protein: 4.0, carbs: 15.0, fat: 5.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_329', name: '焦糖布丁', brand: '甜品店',
      calories: 140, protein: 3.5, carbs: 20.0, fat: 5.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_330', name: '芒果奶酪', brand: '甜品店',
      calories: 150, protein: 4.0, carbs: 24.0, fat: 4.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_331', name: '草莓奶酪', brand: '甜品店',
      calories: 145, protein: 4.0, carbs: 23.0, fat: 4.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_332', name: '抹茶奶酪', brand: '甜品店',
      calories: 155, protein: 4.5, carbs: 22.0, fat: 5.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_333', name: '巧克力奶酪', brand: '甜品店',
      calories: 160, protein: 4.5, carbs: 20.0, fat: 6.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_334', name: '檸檬塔', brand: '甜品店',
      calories: 220, protein: 3.0, carbs: 30.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_335', name: '蘋果派', brand: '甜品店',
      calories: 230, protein: 2.5, carbs: 35.0, fat: 10.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_336', name: '草莓塔', brand: '甜品店',
      calories: 240, protein: 3.5, carbs: 32.0, fat: 11.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_337', name: '藍莓塔', brand: '甜品店',
      calories: 235, protein: 3.5, carbs: 31.0, fat: 10.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_338', name: '巧克力蛋糕', brand: '甜品店',
      calories: 280, protein: 4.5, carbs: 35.0, fat: 14.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_339', name: '草莓蛋糕', brand: '甜品店',
      calories: 260, protein: 4.0, carbs: 32.0, fat: 13.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_340', name: '芋泥蛋糕', brand: '甜品店',
      calories: 270, protein: 4.5, carbs: 33.0, fat: 13.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_341', name: '波士頓派', brand: '甜品店',
      calories: 250, protein: 4.0, carbs: 30.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_342', name: '乳酪蛋糕', brand: '甜品店',
      calories: 290, protein: 6.0, carbs: 28.0, fat: 17.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_343', name: '戚風蛋糕', brand: '甜品店',
      calories: 220, protein: 4.0, carbs: 30.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_344', name: '蜂蜜蛋糕', brand: '甜品店',
      calories: 240, protein: 4.5, carbs: 38.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_345', name: '銅鑼燒', brand: '甜品店',
      calories: 200, protein: 4.0, carbs: 35.0, fat: 5.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_346', name: '大福', brand: '甜品店',
      calories: 180, protein: 3.0, carbs: 28.0, fat: 6.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_347', name: '草莓大福', brand: '甜品店',
      calories: 190, protein: 3.5, carbs: 30.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_348', name: '芒果大福', brand: '甜品店',
      calories: 195, protein: 3.5, carbs: 32.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_349', name: '老婆餅', brand: '甜品店',
      calories: 210, protein: 3.5, carbs: 32.0, fat: 8.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_350', name: '太陽餅', brand: '甜品店',
      calories: 220, protein: 3.0, carbs: 35.0, fat: 8.5,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_351', name: '鳳梨酥', brand: '甜品店',
      calories: 230, protein: 2.5, carbs: 32.0, fat: 10.5,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_352', name: '芋頭酥', brand: '甜品店',
      calories: 220, protein: 3.0, carbs: 30.0, fat: 10.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_353', name: '蛋黃酥', brand: '甜品店',
      calories: 250, protein: 4.5, carbs: 28.0, fat: 13.5,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_354', name: '綠豆糕', brand: '甜品店',
      calories: 180, protein: 4.0, carbs: 28.0, fat: 6.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_355', name: '鳳凰酥', brand: '甜品店',
      calories: 240, protein: 3.5, carbs: 30.0, fat: 12.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_356', name: '花生糖', brand: '糖果店',
      calories: 350, protein: 8.0, carbs: 40.0, fat: 18.0,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_357', name: '牛嘎餅', brand: '糖果店',
      calories: 300, protein: 6.0, carbs: 38.0, fat: 14.0,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_358', name: '黑糖糕', brand: '甜品店',
      calories: 200, protein: 3.5, carbs: 38.0, fat: 4.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_359', name: '桂圓蛋糕', brand: '甜品店',
      calories: 240, protein: 5.0, carbs: 35.0, fat: 9.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_360', name: '咕咕霍夫', brand: '甜品店',
      calories: 210, protein: 4.0, carbs: 30.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),

    // ===== 飲料類 (15項) =====
    const FoodItem(
      id: 'tw_401', name: '珍珠奶茶', brand: '手搖飲',
      calories: 78, protein: 1.2, carbs: 13.0, fat: 2.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_402', name: '波霸奶茶', brand: '手搖飲',
      calories: 75, protein: 1.0, carbs: 12.5, fat: 2.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_403', name: '冬瓜茶', brand: '手搖飲',
      calories: 30, protein: 0.0, carbs: 7.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_404', name: '檸檬愛玉', brand: '手搖飲',
      calories: 25, protein: 0.0, carbs: 6.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_405', name: '豆漿（無糖）', brand: '早餐店',
      calories: 33, protein: 3.0, carbs: 2.0, fat: 1.3,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_406', name: '米漿', brand: '早餐店',
      calories: 55, protein: 1.2, carbs: 10.0, fat: 1.2,
      servingSize: 400, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_407', name: '鮮奶茶', brand: '手搖飲',
      calories: 55, protein: 2.0, carbs: 6.0, fat: 2.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_408', name: '青茶（無糖）', brand: '手搖飲',
      calories: 5, protein: 0.0, carbs: 1.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_409', name: '百香果綠茶', brand: '手搖飲',
      calories: 42, protein: 0.1, carbs: 10.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_410', name: '烏龍奶茶', brand: '手搖飲',
      calories: 65, protein: 1.5, carbs: 9.0, fat: 2.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_411', name: '芋頭牛奶', brand: '手搖飲',
      calories: 95, protein: 2.5, carbs: 15.0, fat: 3.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_412', name: '木瓜牛奶', brand: '手搖飲',
      calories: 85, protein: 2.5, carbs: 14.0, fat: 2.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_413', name: '酪梨牛奶', brand: '手搖飲',
      calories: 110, protein: 3.0, carbs: 10.0, fat: 6.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_414', name: '蜂蜜檸檬', brand: '手搖飲',
      calories: 45, protein: 0.1, carbs: 11.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_415', name: '金桔檸檬', brand: '手搖飲',
      calories: 38, protein: 0.1, carbs: 9.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    // ===== 飲料/手搖類-新增 (35項) tw_416-450 =====
    const FoodItem(
      id: 'tw_416', name: '葡萄柚綠茶', brand: '手搖飲',
      calories: 40, protein: 0.1, carbs: 10.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_417', name: '葡萄柚多多', brand: '手搖飲',
      calories: 55, protein: 0.5, carbs: 12.0, fat: 0.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_418', name: '藍莓茶', brand: '手搖飲',
      calories: 35, protein: 0.1, carbs: 8.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_419', name: '蘋果醋', brand: '手搖飲',
      calories: 45, protein: 0.0, carbs: 11.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_420', name: '梅子醋', brand: '手搖飲',
      calories: 42, protein: 0.0, carbs: 10.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_421', name: '柳橙汁', brand: '手搖飲',
      calories: 45, protein: 0.5, carbs: 11.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_422', name: '葡萄汁', brand: '手搖飲',
      calories: 60, protein: 0.3, carbs: 15.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_423', name: '芭樂汁', brand: '手搖飲',
      calories: 40, protein: 0.3, carbs: 10.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_424', name: '西瓜汁', brand: '手搖飲',
      calories: 38, protein: 0.3, carbs: 9.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_425', name: '芒果汁', brand: '手搖飲',
      calories: 55, protein: 0.3, carbs: 13.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_426', name: '鳳梨汁', brand: '手搖飲',
      calories: 50, protein: 0.3, carbs: 12.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_427', name: '檸檬汁', brand: '手搖飲',
      calories: 30, protein: 0.2, carbs: 7.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_428', name: '金桔汁', brand: '手搖飲',
      calories: 35, protein: 0.2, carbs: 8.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_429', name: '酸梅汁', brand: '手搖飲',
      calories: 40, protein: 0.1, carbs: 10.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_430', name: '洛神花茶', brand: '手搖飲',
      calories: 25, protein: 0.1, carbs: 6.0, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_431', name: '菊花茶', brand: '手搖飲',
      calories: 15, protein: 0.1, carbs: 3.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_432', name: '枸杞茶', brand: '手搖飲',
      calories: 20, protein: 0.2, carbs: 4.5, fat: 0.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_433', name: '桂圓紅棗茶', brand: '手搖飲',
      calories: 50, protein: 0.5, carbs: 12.0, fat: 0.2,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_434', name: '薑茶', brand: '手搖飲',
      calories: 30, protein: 0.1, carbs: 7.0, fat: 0.2,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_435', name: '黑豆茶', brand: '手搖飲',
      calories: 15, protein: 0.5, carbs: 3.0, fat: 0.1,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_436', name: '可可奶茶', brand: '手搖飲',
      calories: 85, protein: 2.0, carbs: 13.0, fat: 3.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_437', name: '奶蓋紅茶', brand: '手搖飲',
      calories: 90, protein: 1.5, carbs: 11.0, fat: 4.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_438', name: '奶蓋綠茶', brand: '手搖飲',
      calories: 85, protein: 1.5, carbs: 10.5, fat: 4.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_439', name: '奶蓋青茶', brand: '手搖飲',
      calories: 80, protein: 1.5, carbs: 10.0, fat: 4.2,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_440', name: '波霸紅茶', brand: '手搖飲',
      calories: 70, protein: 0.8, carbs: 13.5, fat: 1.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_441', name: '波霸綠茶', brand: '手搖飲',
      calories: 65, protein: 0.8, carbs: 13.0, fat: 1.2,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_442', name: '椰果奶茶', brand: '手搖飲',
      calories: 80, protein: 1.0, carbs: 14.0, fat: 2.0,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_443', name: '椰果綠茶', brand: '手搖飲',
      calories: 55, protein: 0.3, carbs: 12.0, fat: 0.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_444', name: '蘆薈綠茶', brand: '手搖飲',
      calories: 50, protein: 0.3, carbs: 11.5, fat: 0.4,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_445', name: '蘆薈汁', brand: '手搖飲',
      calories: 35, protein: 0.2, carbs: 8.5, fat: 0.1,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_446', name: '仙草奶茶', brand: '手搖飲',
      calories: 85, protein: 1.5, carbs: 14.0, fat: 2.5,
      servingSize: 500, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_447', name: '咖啡（美式）', brand: '手搖飲',
      calories: 5, protein: 0.3, carbs: 0.0, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_448', name: '拿鐵咖啡', brand: '手搖飲',
      calories: 65, protein: 3.5, carbs: 7.0, fat: 3.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_449', name: '焦糖瑪奇朵', brand: '手搖飲',
      calories: 120, protein: 3.0, carbs: 18.0, fat: 4.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_450', name: '摩卡咖啡', brand: '手搖飲',
      calories: 130, protein: 3.5, carbs: 20.0, fat: 5.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),

    // ===== 食材類 (15項) =====
    const FoodItem(
      id: 'tw_501', name: '白米飯', brand: '主食',
      calories: 130, protein: 2.5, carbs: 28.0, fat: 0.3,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_502', name: '糙米飯', brand: '主食',
      calories: 112, protein: 2.6, carbs: 23.0, fat: 0.9,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_503', name: '麵條（乾）', brand: '食材',
      calories: 355, protein: 12.0, carbs: 72.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_504', name: '雞蛋', brand: '食材',
      calories: 155, protein: 13.0, carbs: 1.5, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_505', name: '豬絞肉', brand: '食材',
      calories: 250, protein: 17.0, carbs: 0.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_506', name: '牛肉片', brand: '食材',
      calories: 250, protein: 26.0, carbs: 0.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_507', name: '豆腐', brand: '食材',
      calories: 76, protein: 8.0, carbs: 2.0, fat: 4.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_508', name: '豆皮', brand: '食材',
      calories: 240, protein: 18.0, carbs: 5.0, fat: 17.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_509', name: '蝦仁', brand: '食材',
      calories: 99, protein: 21.0, carbs: 0.5, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_510', name: '虱目魚肉', brand: '食材',
      calories: 135, protein: 19.0, carbs: 0.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_511', name: '豬血糕', brand: '食材',
      calories: 130, protein: 5.0, carbs: 22.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_512', name: '貢丸', brand: '食材',
      calories: 200, protein: 14.0, carbs: 5.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_513', name: '甜不辣條', brand: '食材',
      calories: 140, protein: 4.0, carbs: 22.0, fat: 4.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_514', name: ' Tyson 雞胸肉', brand: '食材',
      calories: 120, protein: 26.0, carbs: 0.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_515', name: '五花肉', brand: '食材',
      calories: 320, protein: 15.0, carbs: 0.0, fat: 28.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    // ===== 傳統市場食材-新增 (65項) tw_516-580 =====
    const FoodItem(
      id: 'tw_516', name: '長糯米', brand: '食材',
      calories: 340, protein: 8.0, carbs: 72.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_517', name: '圓糯米', brand: '食材',
      calories: 350, protein: 7.0, carbs: 75.0, fat: 0.8,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_518', name: '蓬萊米', brand: '食材',
      calories: 130, protein: 2.5, carbs: 28.0, fat: 0.3,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_519', name: '在來米', brand: '食材',
      calories: 125, protein: 3.0, carbs: 26.0, fat: 0.4,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_520', name: '紫米', brand: '食材',
      calories: 320, protein: 8.0, carbs: 65.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_521', name: '小米', brand: '食材',
      calories: 360, protein: 10.0, carbs: 70.0, fat: 3.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_522', name: '薏仁', brand: '食材',
      calories: 340, protein: 14.0, carbs: 65.0, fat: 3.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_523', name: '燕麥', brand: '食材',
      calories: 380, protein: 13.0, carbs: 65.0, fat: 7.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_524', name: '大麥', brand: '食材',
      calories: 310, protein: 10.0, carbs: 62.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_525', name: '蕎麥', brand: '食材',
      calories: 320, protein: 13.0, carbs: 62.0, fat: 3.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_526', name: '黃豆', brand: '食材',
      calories: 390, protein: 34.0, carbs: 30.0, fat: 16.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_527', name: '黑豆', brand: '食材',
      calories: 380, protein: 36.0, carbs: 28.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_528', name: '紅豆', brand: '食材',
      calories: 330, protein: 20.0, carbs: 55.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_529', name: '綠豆', brand: '食材',
      calories: 320, protein: 22.0, carbs: 50.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_530', name: '花豆', brand: '食材',
      calories: 310, protein: 19.0, carbs: 52.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_531', name: '皇帝豆', brand: '食材',
      calories: 300, protein: 18.0, carbs: 48.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_532', name: '菱角', brand: '食材',
      calories: 110, protein: 2.0, carbs: 24.0, fat: 0.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_533', name: '蓮子', brand: '食材',
      calories: 330, protein: 17.0, carbs: 60.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_534', name: '芡實', brand: '食材',
      calories: 290, protein: 10.0, carbs: 60.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_535', name: '花生', brand: '食材',
      calories: 560, protein: 25.0, carbs: 20.0, fat: 45.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_536', name: '葵花子', brand: '食材',
      calories: 580, protein: 22.0, carbs: 18.0, fat: 48.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_537', name: '南瓜籽', brand: '食材',
      calories: 550, protein: 30.0, carbs: 15.0, fat: 45.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_538', name: '芝麻', brand: '食材',
      calories: 570, protein: 18.0, carbs: 22.0, fat: 48.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_539', name: '杏仁', brand: '食材',
      calories: 590, protein: 21.0, carbs: 20.0, fat: 50.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_540', name: '核桃', brand: '食材',
      calories: 650, protein: 15.0, carbs: 14.0, fat: 65.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_541', name: '腰果', brand: '食材',
      calories: 550, protein: 18.0, carbs: 30.0, fat: 44.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_542', name: '開心果', brand: '食材',
      calories: 560, protein: 20.0, carbs: 28.0, fat: 45.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_543', name: '夏威夷豆', brand: '食材',
      calories: 700, protein: 8.0, carbs: 14.0, fat: 76.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_544', name: '松子', brand: '食材',
      calories: 640, protein: 14.0, carbs: 19.0, fat: 68.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_545', name: '白芝麻', brand: '食材',
      calories: 560, protein: 17.0, carbs: 23.0, fat: 47.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_546', name: '黑芝麻', brand: '食材',
      calories: 570, protein: 18.0, carbs: 22.0, fat: 48.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_547', name: '乾香菇', brand: '食材',
      calories: 250, protein: 10.0, carbs: 50.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_548', name: '乾木耳', brand: '食材',
      calories: 280, protein: 8.0, carbs: 60.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_549', name: '乾金針花', brand: '食材',
      calories: 240, protein: 10.0, carbs: 48.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_550', name: '乾紫菜', brand: '食材',
      calories: 290, protein: 28.0, carbs: 35.0, fat: 5.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_551', name: '髮菜', brand: '食材',
      calories: 200, protein: 15.0, carbs: 38.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_552', name: '海帶', brand: '食材',
      calories: 60, protein: 5.0, carbs: 10.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_553', name: '昆布', brand: '食材',
      calories: 50, protein: 4.0, carbs: 9.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_554', name: '紫菜酥', brand: '食材',
      calories: 350, protein: 15.0, carbs: 30.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_555', name: '小魚乾', brand: '食材',
      calories: 380, protein: 62.0, carbs: 5.0, fat: 12.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_556', name: '丁香魚', brand: '食材',
      calories: 320, protein: 55.0, carbs: 5.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_557', name: '蝦皮', brand: '食材',
      calories: 280, protein: 50.0, carbs: 5.0, fat: 6.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_558', name: '蝦米', brand: '食材',
      calories: 290, protein: 52.0, carbs: 5.0, fat: 6.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_559', name: '干貝', brand: '食材',
      calories: 300, protein: 60.0, carbs: 5.0, fat: 5.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_560', name: '蚵乾', brand: '食材',
      calories: 280, protein: 45.0, carbs: 15.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_561', name: '章魚乾', brand: '食材',
      calories: 270, protein: 50.0, carbs: 8.0, fat: 5.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_562', name: '烏魚子', brand: '食材',
      calories: 300, protein: 35.0, carbs: 5.0, fat: 16.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_563', name: '鹹蚵仔', brand: '食材',
      calories: 200, protein: 28.0, carbs: 5.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_564', name: '菜脯', brand: '食材',
      calories: 130, protein: 5.0, carbs: 28.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_565', name: '福菜', brand: '食材',
      calories: 120, protein: 4.0, carbs: 25.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_566', name: '梅乾菜', brand: '食材',
      calories: 110, protein: 6.0, carbs: 22.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_567', name: '雪裡紅', brand: '食材',
      calories: 90, protein: 5.0, carbs: 15.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_568', name: '酸菜', brand: '食材',
      calories: 80, protein: 3.0, carbs: 16.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_569', name: '榨菜', brand: '食材',
      calories: 90, protein: 4.0, carbs: 18.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_570', name: '筍乾', brand: '食材',
      calories: 80, protein: 5.0, carbs: 15.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_571', name: '醃蘿蔔', brand: '食材',
      calories: 70, protein: 2.0, carbs: 15.0, fat: 0.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_572', name: '豆腐乳', brand: '食材',
      calories: 150, protein: 8.0, carbs: 10.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_573', name: '豆鼓', brand: '食材',
      calories: 180, protein: 12.0, carbs: 20.0, fat: 7.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_574', name: '破布子', brand: '食材',
      calories: 140, protein: 5.0, carbs: 30.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_575', name: '黑棗', brand: '食材',
      calories: 250, protein: 3.0, carbs: 60.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_576', name: '紅棗', brand: '食材',
      calories: 260, protein: 4.0, carbs: 58.0, fat: 2.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_577', name: '枸杞', brand: '食材',
      calories: 250, protein: 10.0, carbs: 50.0, fat: 3.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_578', name: '龍眼乾', brand: '食材',
      calories: 280, protein: 4.0, carbs: 65.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_579', name: '荔枝乾', brand: '食材',
      calories: 270, protein: 4.0, carbs: 62.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_580', name: '葡萄乾', brand: '食材',
      calories: 300, protein: 3.0, carbs: 75.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    // ===== 加工食品 (40項) tw_601-640 =====
    const FoodItem(
      id: 'tw_601', name: '貢丸', brand: '加工食品',
      calories: 200, protein: 14.0, carbs: 5.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_602', name: '魚丸', brand: '加工食品',
      calories: 150, protein: 12.0, carbs: 8.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_603', name: '蝦丸', brand: '加工食品',
      calories: 160, protein: 15.0, carbs: 6.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_604', name: '花枝丸', brand: '加工食品',
      calories: 170, protein: 13.0, carbs: 10.0, fat: 9.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_605', name: '香菇丸', brand: '加工食品',
      calories: 180, protein: 8.0, carbs: 18.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_606', name: '玉米丸', brand: '加工食品',
      calories: 175, protein: 6.0, carbs: 22.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_607', name: '起司丸', brand: '加工食品',
      calories: 220, protein: 10.0, carbs: 15.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_608', name: '福州丸', brand: '加工食品',
      calories: 190, protein: 12.0, carbs: 14.0, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_609', name: '燕餃', brand: '加工食品',
      calories: 200, protein: 12.0, carbs: 15.0, fat: 11.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_610', name: '魚餃', brand: '加工食品',
      calories: 210, protein: 14.0, carbs: 12.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_611', name: '蝦餃', brand: '加工食品',
      calories: 190, protein: 14.0, carbs: 15.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_612', name: '水晶餃', brand: '加工食品',
      calories: 180, protein: 8.0, carbs: 22.0, fat: 8.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_613', name: '小香腸', brand: '加工食品',
      calories: 280, protein: 10.0, carbs: 6.0, fat: 24.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_614', name: '大香腸', brand: '加工食品',
      calories: 300, protein: 12.0, carbs: 8.0, fat: 25.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_615', name: '德國香腸', brand: '加工食品',
      calories: 290, protein: 14.0, carbs: 5.0, fat: 25.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_616', name: '義式香腸', brand: '加工食品',
      calories: 280, protein: 13.0, carbs: 5.0, fat: 24.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_617', name: '熱狗', brand: '加工食品',
      calories: 260, protein: 9.0, carbs: 18.0, fat: 18.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_618', name: '培根', brand: '加工食品',
      calories: 350, protein: 15.0, carbs: 2.0, fat: 31.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_619', name: '火腿片', brand: '加工食品',
      calories: 220, protein: 18.0, carbs: 5.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_620', name: '義美火腿', brand: '加工食品',
      calories: 200, protein: 16.0, carbs: 4.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_621', name: '肉鬆', brand: '加工食品',
      calories: 320, protein: 28.0, carbs: 15.0, fat: 16.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_622', name: '肉乾', brand: '加工食品',
      calories: 350, protein: 25.0, carbs: 20.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_623', name: '豬肉乾', brand: '加工食品',
      calories: 340, protein: 24.0, carbs: 22.0, fat: 18.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_624', name: '牛肉乾', brand: '加工食品',
      calories: 360, protein: 30.0, carbs: 18.0, fat: 18.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_625', name: '魚肉乾', brand: '加工食品',
      calories: 280, protein: 30.0, carbs: 15.0, fat: 12.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_626', name: '魷魚絲', brand: '加工食品',
      calories: 270, protein: 35.0, carbs: 12.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_627', name: '小卷片', brand: '加工食品',
      calories: 260, protein: 32.0, carbs: 10.0, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_628', name: '蝦味先', brand: '加工食品',
      calories: 450, protein: 10.0, carbs: 55.0, fat: 22.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_629', name: '蝦餅', brand: '加工食品',
      calories: 420, protein: 8.0, carbs: 50.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_630', name: '洋芋片', brand: '加工食品',
      calories: 500, protein: 7.0, carbs: 53.0, fat: 30.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_631', name: '薯條（包裝）', brand: '加工食品',
      calories: 480, protein: 6.0, carbs: 52.0, fat: 28.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_632', name: '爆米花', brand: '加工食品',
      calories: 380, protein: 8.0, carbs: 50.0, fat: 18.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_633', name: '科學麵', brand: '加工食品',
      calories: 470, protein: 10.0, carbs: 60.0, fat: 21.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_634', name: '王子麵', brand: '加工食品',
      calories: 450, protein: 11.0, carbs: 58.0, fat: 19.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_635', name: '雞汁麵', brand: '加工食品',
      calories: 460, protein: 10.0, carbs: 58.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_636', name: '泡麵（牛肉）', brand: '加工食品',
      calories: 440, protein: 10.0, carbs: 55.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_637', name: '泡麵（羊肉）', brand: '加工食品',
      calories: 430, protein: 11.0, carbs: 53.0, fat: 19.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_638', name: '泡麵（海鮮）', brand: '加工食品',
      calories: 420, protein: 12.0, carbs: 52.0, fat: 18.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_639', name: '維力炸醬麵', brand: '加工食品',
      calories: 450, protein: 12.0, carbs: 55.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_640', name: '肉醬罐頭', brand: '加工食品',
      calories: 280, protein: 15.0, carbs: 8.0, fat: 20.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),

    // ===== 速食/連鎖 (40項) tw_641-680 =====
    const FoodItem(
      id: 'tw_641', name: '麥當勞大麥克', brand: '麥當勞',
      calories: 560, protein: 26.0, carbs: 42.0, fat: 30.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_642', name: '麥當勞薯條（大）', brand: '麥當勞',
      calories: 430, protein: 7.0, carbs: 53.0, fat: 22.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_643', name: '麥當勞雞塊（6塊）', brand: '麥當勞',
      calories: 280, protein: 15.0, carbs: 18.0, fat: 17.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_644', name: '麥香魚', brand: '麥當勞',
      calories: 380, protein: 17.0, carbs: 38.0, fat: 18.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_645', name: '麥香雞', brand: '麥當勞',
      calories: 430, protein: 22.0, carbs: 35.0, fat: 23.0,
      servingSize: 160, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_646', name: '麥當勞飲料（可樂）', brand: '麥當勞',
      calories: 140, protein: 0.0, carbs: 35.0, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_647', name: '麥當勞冰淇淋', brand: '麥當勞',
      calories: 190, protein: 3.5, carbs: 28.0, fat: 7.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_648', name: '麥克雞腿', brand: '麥當勞',
      calories: 350, protein: 22.0, carbs: 18.0, fat: 20.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_649', name: '肯德基炸雞', brand: '肯德基',
      calories: 300, protein: 20.0, carbs: 12.0, fat: 19.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_650', name: '肯德基全家桶', brand: '肯德基',
      calories: 2800, protein: 160.0, carbs: 180.0, fat: 160.0,
      servingSize: 1000, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_651', name: '肯德基薯條', brand: '肯德基',
      calories: 400, protein: 6.0, carbs: 50.0, fat: 20.0,
      servingSize: 130, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_652', name: '肯德基蛋塔', brand: '肯德基',
      calories: 190, protein: 4.5, carbs: 22.0, fat: 10.0,
      servingSize: 80, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_653', name: '摩斯漢堡', brand: '摩斯',
      calories: 480, protein: 24.0, carbs: 40.0, fat: 25.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_654', name: '摩斯薯條', brand: '摩斯',
      calories: 320, protein: 5.0, carbs: 40.0, fat: 16.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_655', name: '漢堡王大皇堡', brand: '漢堡王',
      calories: 600, protein: 28.0, carbs: 45.0, fat: 33.0,
      servingSize: 220, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_656', name: '漢堡王薯條', brand: '漢堡王',
      calories: 380, protein: 6.0, carbs: 48.0, fat: 18.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_657', name: 'SUBWAY潛艇堡', brand: 'SUBWAY',
      calories: 350, protein: 22.0, carbs: 40.0, fat: 12.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_658', name: 'SUBWAY沙拉', brand: 'SUBWAY',
      calories: 50, protein: 3.0, carbs: 8.0, fat: 1.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_659', name: '達美樂披薩', brand: '達美樂',
      calories: 250, protein: 10.0, carbs: 28.0, fat: 11.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_660', name: '必勝客披薩', brand: '必勝客',
      calories: 260, protein: 11.0, carbs: 30.0, fat: 11.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_661', name: '必勝客義大利麵', brand: '必勝客',
      calories: 380, protein: 14.0, carbs: 45.0, fat: 16.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_662', name: '披薩（海鮮）', brand: '連鎖',
      calories: 230, protein: 10.0, carbs: 26.0, fat: 10.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_663', name: '披薩（水果）', brand: '連鎖',
      calories: 220, protein: 8.0, carbs: 30.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_664', name: '炸雞腿（速食）', brand: '速食店',
      calories: 290, protein: 18.0, carbs: 10.0, fat: 19.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_665', name: '炸雞翅（速食）', brand: '速食店',
      calories: 220, protein: 16.0, carbs: 8.0, fat: 14.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_666', name: '洋蔥圈（速食）', brand: '速食店',
      calories: 270, protein: 4.0, carbs: 32.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_667', name: '雞柳條', brand: '速食店',
      calories: 250, protein: 16.0, carbs: 15.0, fat: 15.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_668', name: '魷魚圈（速食）', brand: '速食店',
      calories: 230, protein: 14.0, carbs: 18.0, fat: 13.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_669', name: '麥當勞蘋果派', brand: '麥當勞',
      calories: 240, protein: 3.0, carbs: 32.0, fat: 11.5,
      servingSize: 90, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_670', name: '肯德基玉米濃湯', brand: '肯德基',
      calories: 110, protein: 3.0, carbs: 14.0, fat: 5.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_671', name: '摩斯紅茶', brand: '摩斯',
      calories: 35, protein: 0.1, carbs: 8.5, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_672', name: '摩斯奶茶', brand: '摩斯',
      calories: 80, protein: 2.0, carbs: 12.0, fat: 2.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_673', name: 'SUBWAY餅乾', brand: 'SUBWAY',
      calories: 200, protein: 2.0, carbs: 28.0, fat: 9.5,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_674', name: '冰炫風', brand: '麥當勞',
      calories: 280, protein: 5.0, carbs: 40.0, fat: 12.0,
      servingSize: 180, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_675', name: '聖代（巧克力）', brand: '麥當勞',
      calories: 180, protein: 4.0, carbs: 28.0, fat: 6.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_676', name: '聖代（草莓）', brand: '麥當勞',
      calories: 170, protein: 4.0, carbs: 27.0, fat: 5.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_677', name: '百事可樂', brand: '速食店',
      calories: 150, protein: 0.0, carbs: 38.0, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_678', name: '可口可樂', brand: '速食店',
      calories: 140, protein: 0.0, carbs: 35.0, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_679', name: '橙汁（連鎖）', brand: '速食店',
      calories: 55, protein: 0.5, carbs: 13.0, fat: 0.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_680', name: '冰美式咖啡', brand: '連鎖咖啡',
      calories: 10, protein: 0.3, carbs: 0.0, fat: 0.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),

    // ===== 素食 (30項) tw_701-730 =====
    const FoodItem(
      id: 'tw_701', name: '素肉燥飯', brand: '素食餐廳',
      calories: 230, protein: 6.0, carbs: 38.0, fat: 6.0,
      servingSize: 250, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_702', name: '素排飯', brand: '素食餐廳',
      calories: 350, protein: 12.0, carbs: 48.0, fat: 12.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_703', name: '素雞腿飯', brand: '素食餐廳',
      calories: 380, protein: 15.0, carbs: 45.0, fat: 14.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_704', name: '素魚排飯', brand: '素食餐廳',
      calories: 320, protein: 14.0, carbs: 42.0, fat: 10.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_705', name: '素三杯飯', brand: '素食餐廳',
      calories: 340, protein: 10.0, carbs: 48.0, fat: 12.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_706', name: '素炒麵', brand: '素食餐廳',
      calories: 200, protein: 5.0, carbs: 32.0, fat: 6.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_707', name: '素炒米粉', brand: '素食餐廳',
      calories: 190, protein: 4.5, carbs: 30.0, fat: 5.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_708', name: '素燴飯', brand: '素食餐廳',
      calories: 280, protein: 8.0, carbs: 40.0, fat: 9.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_709', name: '素咖喱飯', brand: '素食餐廳',
      calories: 310, protein: 8.0, carbs: 45.0, fat: 11.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_710', name: '素湯麵', brand: '素食餐廳',
      calories: 170, protein: 5.0, carbs: 28.0, fat: 4.0,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_711', name: '素餛飩麵', brand: '素食餐廳',
      calories: 190, protein: 6.0, carbs: 30.0, fat: 5.5,
      servingSize: 350, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_712', name: '素水餃', brand: '素食餐廳',
      calories: 180, protein: 6.0, carbs: 25.0, fat: 6.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_713', name: '素蒸餃', brand: '素食餐廳',
      calories: 170, protein: 5.5, carbs: 24.0, fat: 6.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_714', name: '素鍋貼', brand: '素食餐廳',
      calories: 200, protein: 7.0, carbs: 24.0, fat: 9.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_715', name: '素春捲', brand: '素食餐廳',
      calories: 180, protein: 5.0, carbs: 22.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_716', name: '素潤餅', brand: '素食餐廳',
      calories: 190, protein: 6.0, carbs: 24.0, fat: 8.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_717', name: '素肉圓', brand: '素食餐廳',
      calories: 180, protein: 4.5, carbs: 28.0, fat: 5.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_718', name: '素碗粿', brand: '素食餐廳',
      calories: 120, protein: 3.0, carbs: 22.0, fat: 2.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_719', name: '素筒仔米糕', brand: '素食餐廳',
      calories: 170, protein: 4.0, carbs: 28.0, fat: 4.5,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_720', name: '素臭豆腐', brand: '素食餐廳',
      calories: 150, protein: 8.0, carbs: 10.0, fat: 9.0,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_721', name: '素蚵仔煎', brand: '素食餐廳',
      calories: 180, protein: 7.0, carbs: 22.0, fat: 7.5,
      servingSize: 200, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_722', name: '素鹹酥雞', brand: '素食餐廳',
      calories: 200, protein: 12.0, carbs: 15.0, fat: 11.5,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_723', name: '素雞排', brand: '素食餐廳',
      calories: 220, protein: 14.0, carbs: 12.0, fat: 14.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_724', name: '素熱狗', brand: '素食餐廳',
      calories: 180, protein: 8.0, carbs: 18.0, fat: 9.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_725', name: '素香腸', brand: '素食餐廳',
      calories: 200, protein: 10.0, carbs: 15.0, fat: 12.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_726', name: '素漢堡', brand: '素食餐廳',
      calories: 280, protein: 10.0, carbs: 35.0, fat: 12.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_727', name: '素披薩', brand: '素食餐廳',
      calories: 210, protein: 8.0, carbs: 28.0, fat: 8.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_728', name: '素咖喱麵', brand: '素食餐廳',
      calories: 250, protein: 7.0, carbs: 35.0, fat: 9.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_729', name: '素麻醬麵', brand: '素食餐廳',
      calories: 280, protein: 7.0, carbs: 32.0, fat: 14.0,
      servingSize: 300, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_730', name: '素炸醬麵', brand: '素食餐廳',
      calories: 230, protein: 7.0, carbs: 32.0, fat: 8.5,
      servingSize: 300, barcode: null, imageUrl: null,
    ),

    // ===== 嬰幼兒/銀髮 (20項) tw_801-820 =====
    const FoodItem(
      id: 'tw_801', name: '嬰兒米糊', brand: '嬰幼兒食品',
      calories: 80, protein: 2.0, carbs: 16.0, fat: 1.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_802', name: '嬰兒水果泥', brand: '嬰幼兒食品',
      calories: 60, protein: 0.5, carbs: 14.0, fat: 0.2,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_803', name: '嬰兒蔬菜泥', brand: '嬰幼兒食品',
      calories: 40, protein: 1.5, carbs: 8.0, fat: 0.3,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_804', name: '嬰兒肉泥', brand: '嬰幼兒食品',
      calories: 100, protein: 12.0, carbs: 4.0, fat: 4.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_805', name: '嬰兒魚肉泥', brand: '嬰幼兒食品',
      calories: 90, protein: 14.0, carbs: 3.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_806', name: '嬰兒配方奶', brand: '嬰幼兒食品',
      calories: 75, protein: 3.5, carbs: 8.0, fat: 3.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_807', name: '幼兒成長奶粉', brand: '嬰幼兒食品',
      calories: 80, protein: 4.0, carbs: 9.0, fat: 3.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_808', name: '銀髮族配方奶粉', brand: '銀髮族食品',
      calories: 70, protein: 5.0, carbs: 8.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_809', name: '銀髮族營養補充品', brand: '銀髮族食品',
      calories: 50, protein: 4.0, carbs: 6.0, fat: 1.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_810', name: '銀髮友善食品（軟質）', brand: '銀髮族食品',
      calories: 90, protein: 5.0, carbs: 12.0, fat: 3.0,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_811', name: '銀髮族即食粥', brand: '銀髮族食品',
      calories: 80, protein: 3.5, carbs: 12.0, fat: 2.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_812', name: '嬰幼兒餅乾', brand: '嬰幼兒食品',
      calories: 380, protein: 6.0, carbs: 55.0, fat: 16.0,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_813', name: '嬰幼兒米餅', brand: '嬰幼兒食品',
      calories: 350, protein: 7.0, carbs: 50.0, fat: 14.0,
      servingSize: 50, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_814', name: '嬰幼兒水果條', brand: '嬰幼兒食品',
      calories: 300, protein: 4.0, carbs: 48.0, fat: 10.0,
      servingSize: 50, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_815', name: '嬰幼兒牙餅', brand: '嬰幼兒食品',
      calories: 360, protein: 8.0, carbs: 52.0, fat: 14.0,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_816', name: '銀髮族穀物棒', brand: '銀髮族食品',
      calories: 340, protein: 8.0, carbs: 48.0, fat: 14.0,
      servingSize: 60, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_817', name: '銀髮族優格', brand: '銀髮族食品',
      calories: 90, protein: 5.0, carbs: 12.0, fat: 3.0,
      servingSize: 120, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_818', name: '銀髮族布丁', brand: '銀髮族食品',
      calories: 100, protein: 3.5, carbs: 16.0, fat: 2.5,
      servingSize: 100, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_819', name: '銀髮族豆花', brand: '銀髮族食品',
      calories: 85, protein: 4.0, carbs: 12.0, fat: 2.0,
      servingSize: 150, barcode: null, imageUrl: null,
    ),
    const FoodItem(
      id: 'tw_820', name: '銀髮族杏仁豆腐', brand: '銀髮族食品',
      calories: 95, protein: 3.5, carbs: 12.0, fat: 4.0,
      servingSize: 120, barcode: null, imageUrl: null,
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
      _foods.firstWhere((f) => f.id == 'tw_401'), // 珍珠奶茶
      _foods.firstWhere((f) => f.id == 'tw_101'), // 雞腿便當
      _foods.firstWhere((f) => f.id == 'tw_104'), // 滷肉飯
      _foods.firstWhere((f) => f.id == 'tw_106'), // 牛肉麵
      _foods.firstWhere((f) => f.id == 'tw_203'), // 鹹酥雞
      _foods.firstWhere((f) => f.id == 'tw_004'), // 小籠包
      _foods.firstWhere((f) => f.id == 'tw_301'), // 豆花
      _foods.firstWhere((f) => f.id == 'tw_202'), // 蚵仔煎
      _foods.firstWhere((f) => f.id == 'tw_211'), // 水餃
      _foods.firstWhere((f) => f.id == 'tw_102'), // 排骨便當
      _foods.firstWhere((f) => f.id == 'tw_402'), // 波霸奶茶
      _foods.firstWhere((f) => f.id == 'tw_405'), // 豆漿
    ];
  }
}
