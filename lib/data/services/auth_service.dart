// Library: Firebase/Guest 認證服務
//
// 目前使用本機 Guest 模式（免登入即可使用）
// Firebase 設定後替換為 firebase_pending/auth_service.dart
//
// 切換方式：
// 1. 取消 pubspec.yaml 的 firebase_* 註解
// 2. 放 google-services.json 和 GoogleService-Info.plist
// 3. 把本檔案替換為 firebase_pending/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

// Library: Firebase/Guest 認證服務

/// 登入結果
enum AuthResult {
  success,
  cancelled,
  error,
}

extension AuthResultExtension on AuthResult {
  bool get isSuccess => this == AuthResult.success;
  bool get isCancelled => this == AuthResult.cancelled;
  bool get isError => this == AuthResult.error;
}

class GuestUser {
  final String id;
  final String? email;
  final String? displayName;

  GuestUser({required this.id, this.email, this.displayName});

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'displayName': displayName};
}

class AuthService {
  static const String _keyGuestId = 'guest_user_id';
  static const String _keyIsGuest = 'is_guest_mode';

  GuestUser? _currentGuest;

  Stream<GuestUser?> get authStateChanges async* {
    yield _currentGuest;
  }

  GuestUser? get currentUser => _currentGuest;
  bool get isSignedIn => _currentGuest != null;

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

  Future<AuthResult> signInAsGuest() async {
    await initGuestMode();
    return AuthResult.success;
  }

  Future<AuthResult> signInWithGoogle() async => signInAsGuest();
  Future<AuthResult> signInWithEmail(String email, String password) async => signInAsGuest();
  Future<AuthResult> registerWithEmail(String email, String password) async => signInAsGuest();

  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return AuthResult.error;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGuestId);
    await prefs.remove(_keyIsGuest);
    _currentGuest = null;
  }
}
