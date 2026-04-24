import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_profile.dart';

/// Firebase 認證服務
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    webClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // 從 Firebase Console 取得
  );

  /// 監聽登入狀態變化
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 取得目前登入的使用者
  User? get currentUser => _auth.currentUser;

  /// 是否有登入
  bool get isSignedIn => _auth.currentUser != null;

  /// 以 Google 帳號登入
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.cancelled;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(e.message ?? '登入失敗');
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  /// 以 Email + 密碼註冊
  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.code));
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  /// 以 Email + 密碼登入
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.code));
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  /// 傳送密碼重設 Email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.code));
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  /// 登出
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// 的地圖 Auth 錯誤訊息（改為繁體中文）
  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return '找不到這個帳號';
      case 'wrong-password':
        return '密碼錯誤';
      case 'email-already-in-use':
        return '這個 Email 已被註冊';
      case 'invalid-email':
        return 'Email 格式不正確';
      case 'weak-password':
        return '密碼強度太弱（至少需要 6 個字元）';
      case 'user-disabled':
        return '此帳號已被停用';
      case 'too-many-requests':
        return '嘗試次數過多，請稍後再試';
      case 'network-request-failed':
        return '網路連線失敗';
      default:
        return '登入失敗：$code';
    }
  }
}

/// 登入結果
enum AuthResult {
  success,
  cancelled,
  error,
}

/// 擴充方法：取得更詳細的錯誤資訊
extension AuthResultExtension on AuthResult {
  bool get isSuccess => this == AuthResult.success;
  bool get isCancelled => this == AuthResult.cancelled;
  bool get isError => this == AuthResult.error;
}
