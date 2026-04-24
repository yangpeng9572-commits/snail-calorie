// Library: Firebase/Guest 認證服務
/// 目前使用本機 Guest 模式，未來只需：
/// 1. 取消 pubspec.yaml 的 firebase_* 註解
/// 2. 放 google-services.json 和 GoogleService-Info.plist
/// 3. 取消以下 Firebase.initializeApp() 註解
///
/// 已預留完整 Firebase Auth 實作在 firebase_pending/auth_service.dart
///
/// 目前實作：Guest 模式（不需登入即可使用）
import 'package:shared_preferences/shared_preferences.dart';

/// 登入結果
enum AuthResult {
  success,
  cancelled,
  error,
}

/// 擴充方法
extension AuthResultExtension on AuthResult {
  bool get isSuccess => this == AuthResult.success;
  bool get isCancelled => this == AuthResult.cancelled;
  bool get isError => this == AuthResult.error;
}

/// 登入錯誤（攜帶錯誤訊息）
class AuthError {
  final String message;
  const AuthError(this.message);

  @override
  String toString() => message;
}

/// Guest 模式下的使用者資料
class GuestUser {
  final String id;
  final String? email;
  final String? displayName;

  GuestUser({required this.id, this.email, this.displayName});

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
  };
}

/// 認證服務（目前為 Guest 模式，Firebase 設定後替換 firebase_pending/auth_service.dart）
class AuthService {
  static const String _keyGuestId = 'guest_user_id';
  static const String _keyIsGuest = 'is_guest_mode';

  GuestUser? _currentGuest;

  /// 監聽登入狀態變化（Guest 模式永遠是已登入）
  Stream<GuestUser?> get authStateChanges async* {
    yield _currentGuest;
    // Guest 模式不變，yield 一次就結束
    // Firebase 模式會變成真的 stream
  }

  /// 取得目前的使用者
  GuestUser? get currentUser {
    if (_currentGuest != null) return _currentGuest;
    return null; // 尚未初始化
  }

  /// 是否有登入
  bool get isSignedIn => _currentGuest != null;

  /// 初始化 Guest 模式（App 啟動時呼叫）
  Future<GuestUser> initGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    String? guestId = prefs.getString(_keyGuestId);

    if (guestId == null) {
      guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_keyGuestId, guestId);
      await prefs.setBool(_keyIsGuest, true);
    }

    _currentGuest = GuestUser(id: guestId);
    return _currentGuest!;
  }

  /// Guest 模式：以訪客身份使用（直接成功）
  Future<AuthResult> signInAsGuest() async {
    await initGuestMode();
    return AuthResult.success;
  }

  /// Google 登入（Firebase 設定後啟用）
  /// 目前呼叫時直接以 Guest 登入
  Future<AuthResult> signInWithGoogle() async {
    // TODO: Firebase 設定後，替換為 firebase_pending/auth_service.dart 的實作
    return await signInAsGuest();
  }

  /// Email 登入（Firebase 設定後啟用）
  Future<AuthResult> signInWithEmail(String email, String password) async {
    // TODO: Firebase 設定後，替換為 firebase_pending/auth_service.dart 的實作
    return await signInAsGuest();
  }

  /// Email 註冊（Firebase 設定後啟用）
  Future<AuthResult> registerWithEmail(String email, String password) async {
    // TODO: Firebase 設定後，替換為 firebase_pending/auth_service.dart 的實作
    return await signInAsGuest();
  }

  /// 傳送密碼重設 Email（Guest 模式不支援）
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return AuthResult.error; // Guest 模式不支援密碼重設
  }

  /// 登出（Guest 模式清除本地資料）
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGuestId);
    await prefs.remove(_keyIsGuest);
    _currentGuest = null;
  }
}
