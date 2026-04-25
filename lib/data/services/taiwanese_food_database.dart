import '../models/food_item.dart';

/// 台灣本地食物資料庫（離線可用）
/// 收錄 120 項熱門台灣美食，營養數據以每100g為基準
class TaiwaneseFoodDatabase {
  static final List<FoodItem> _foods = [
    // ===== 早餐類 (20項) =====
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

    // ===== 便當/主食類 (20項) =====
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

    // ===== 小吃類 (30項) =====
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
