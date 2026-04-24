import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/daily_log.dart';
import '../models/food_item.dart';
import '../../core/constants/app_constants.dart';

/// Firestore 雲端同步服務
class FirestoreService {
  static const String _usersCollection = 'users';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;
  bool get isLoggedIn => _uid != null;

  DocumentReference get _userDoc => _firestore.collection(_usersCollection).doc(_uid!);

  // ==================== 用戶資料同步 ====================

  /// 儲存用戶資料到 Firestore
  Future<void> saveUserProfile(UserProfile profile) async {
    if (!isLoggedIn) return;
    await _userDoc.set({'profile': profile.toJson()}, SetOptions(merge: true));
  }

  /// 從 Firestore 讀取用戶資料
  Future<UserProfile?> getUserProfile() async {
    if (!isLoggedIn) return null;
    final doc = await _userDoc.get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null || data['profile'] == null) return null;
    return UserProfile.fromJson(data['profile'] as Map<String, dynamic>);
  }

  // ==================== 每日日誌同步 ====================

  /// 儲存單日日誌
  Future<void> saveDailyLog(DailyLog log) async {
    if (!isLoggedIn) return;
    await _userDoc.collection('daily_logs').doc(log.date).set(
      log.toJson(),
      SetOptions(merge: true),
    );
  }

  /// 讀取單日日誌
  Future<DailyLog?> getDailyLog(String date) async {
    if (!isLoggedIn) return null;
    final doc = await _userDoc.collection('daily_logs').doc(date).get();
    if (!doc.exists || doc.data() == null) return null;
    return DailyLog.fromJson(doc.data()!);
  }

  /// 讀取多日日誌（適用於同步）
  Future<Map<String, DailyLog>> getDailyLogs(List<String> dates) async {
    if (!isLoggedIn) return {};

    final logs = <String, DailyLog>{};
    final futures = dates.map((date) async {
      final log = await getDailyLog(date);
      if (log != null) logs[date] = log;
    });

    await Future.wait(futures);
    return logs;
  }

  // ==================== 收藏食物同步 ====================

  /// 儲存收藏食物列表
  Future<void> saveFavoriteFoods(List<FoodItem> foods) async {
    if (!isLoggedIn) return;
    final list = foods.map((f) => f.toJson()).toList();
    await _userDoc.set({'favorites': list}, SetOptions(merge: true));
  }

  /// 讀取收藏食物
  Future<List<FoodItem>> getFavoriteFoods() async {
    if (!isLoggedIn) return [];
    final doc = await _userDoc.get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null || data['favorites'] == null) return [];
    return (data['favorites'] as List)
        .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ==================== 體重歷史同步 ====================

  /// 儲存體重記錄
  Future<void> saveWeightRecord(String date, double weight) async {
    if (!isLoggedIn) return;
    await _userDoc.collection('weight_records').doc(date).set({
      'date': date,
      'weight': weight,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// 讀取體重歷史（最近 N 天）
  Future<List<Map<String, dynamic>>> getWeightHistory({int days = 30}) async {
    if (!isLoggedIn) return [];

    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    final snapshot = await _userDoc
        .collection('weight_records')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(startDate))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ==================== 衝突處理 ====================

  /// 智能合併：取較新者
  /// 如果 Firestore 的更新时间比本地新，用 Firestore 的
  /// 否则保留本地数据
  Future<DailyLog?> mergeDailyLog(String date, DailyLog localLog) async {
    if (!isLoggedIn) return localLog;

    final remoteDoc = await _userDoc.collection('daily_logs').doc(date).get();
    if (!remoteDoc.exists) {
      // 遠端沒有，上傳本地
      await saveDailyLog(localLog);
      return localLog;
    }

    final remoteData = remoteDoc.data()!;
    final remoteTimestamp = remoteData['_updatedAt'] as Timestamp?;
    final localTimestamp = localLog.toJson()['_updatedAt'] as String?;

    if (remoteTimestamp != null && localTimestamp != null) {
      final remoteTime = remoteTimestamp.toDate();
      final localTime = DateTime.parse(localTimestamp);
      if (remoteTime.isAfter(localTime)) {
        // 遠端較新
        return DailyLog.fromJson(remoteData);
      }
    }

    // 本地較新或相同，上傳本地
    await saveDailyLog(localLog);
    return localLog;
  }
}
