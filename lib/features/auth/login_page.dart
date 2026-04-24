import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';

/// 登入頁面
class LoginPage extends ConsumerStatefulWidget {
  final VoidCallback onSignInSuccess;

  const LoginPage({super.key, required this.onSignInSuccess});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _resetEmailController = TextEditingController();

  bool _isLoading = false;
  bool _isRegisterMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.signInWithGoogle();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result == AuthResult.success) {
      _onLoginSuccess();
    } else if (result == AuthResult.cancelled) {
      // 用户取消，不显示错误
    } else {
      setState(() => _errorMessage = 'Google 登入失敗');
    }
  }

  Future<void> _handleEmailSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = '請填寫 Email 和密碼');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result == AuthResult.success) {
      _onLoginSuccess();
    } else {
      setState(() => _errorMessage = 'Email 或密碼錯誤');
    }
  }

  Future<void> _handleEmailRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = '請填寫所有欄位');
      return;
    }

    if (password != confirm) {
      setState(() => _errorMessage = '兩次密碼不一致');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = '密碼至少需要 6 個字元');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.registerWithEmail(email, password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result == AuthResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('註冊成功！請至 Email 驗證')),
      );
      setState(() => _isRegisterMode = false);
    } else {
      setState(() => _errorMessage = '註冊失敗，請稍後再試');
    }
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重設密碼'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('輸入你的 Email，我們會寄送重設密碼連結'),
            const SizedBox(height: 16),
            TextField(
              controller: _resetEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'your@email.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _resetEmailController.text.trim();
              if (email.isEmpty) return;

              await _authService.sendPasswordResetEmail(email);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已寄送重設密碼 Email')),
              );
            },
            child: const Text('傳送'),
          ),
        ],
      ),
    );
  }

  void _onLoginSuccess() {
    // 觸發Provider刷新，通知app重新檢查auth狀態
    ref.invalidate(userProfileProvider);
    widget.onSignInSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo 區
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                '食刻輕卡',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isRegisterMode ? '建立新帳號' : '登入你的帳號',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 40),

              // 錯誤訊息
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppTheme.errorColor),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Google 登入按鈕
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                icon: Image.network(
                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                  width: 20,
                  height: 20,
                  errorBuilder: (_, __, ___) => const Icon(Icons.login),
                ),
                label: const Text('以 Google 登入'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),

              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('或', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Email 輸入框
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
              const SizedBox(height: 12),

              // 密碼輸入框
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密碼',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_off),
                    onPressed: () {},
                  ),
                ),
                obscureText: true,
              ),

              // 確認密碼（註冊模式）
              if (_isRegisterMode) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: '確認密碼',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
              ],

              const SizedBox(height: 24),

              // 提交按鈕
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_isRegisterMode ? _handleEmailRegister : _handleEmailSignIn),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isRegisterMode ? '註冊' : '登入'),
              ),

              const SizedBox(height: 12),

              // 模式切換 / 忘記密碼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      _isRegisterMode = !_isRegisterMode;
                      _errorMessage = null;
                    }),
                    child: Text(_isRegisterMode ? '已經有帳號？登入' : '還沒有帳號？註冊'),
                  ),
                  if (!_isRegisterMode)
                    TextButton(
                      onPressed: _showPasswordResetDialog,
                      child: const Text('忘記密碼？'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
