import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/auth_service.dart';

/// 登入頁面（目前為 Guest 模式：直接進入 App，Firebase 設定後變成完整登入）
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
  final _confirmController = TextEditingController();
  final _resetEmailController = TextEditingController();

  bool _isLoading = false;
  bool _isRegisterMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  Future<void> _guestSignIn() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final result = await _authService.signInAsGuest();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result == AuthResult.success) {
      widget.onSignInSuccess();
    } else {
      setState(() => _errorMessage = '無法以訪客模式進入');
    }
  }

  Future<void> _googleSignIn() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final result = await _authService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result == AuthResult.success) {
      widget.onSignInSuccess();
    } else if (result != AuthResult.cancelled) {
      setState(() => _errorMessage = 'Google 登入失敗');
    }
  }

  Future<void> _emailSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = '請填寫 Email 和密碼');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });
    final result = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result == AuthResult.success) {
      widget.onSignInSuccess();
    } else {
      setState(() => _errorMessage = 'Email 或密碼錯誤');
    }
  }

  Future<void> _emailRegister() async {
    final email = _emailController.text.trim();
    final pw = _passwordController.text;
    if (email.isEmpty || pw.isEmpty) {
      setState(() => _errorMessage = '請填寫所有欄位');
      return;
    }
    if (pw != _confirmController.text) {
      setState(() => _errorMessage = '兩次密碼不一致');
      return;
    }
    if (pw.length < 6) {
      setState(() => _errorMessage = '密碼至少需要 6 個字元');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });
    final result = await _authService.registerWithEmail(email, pw);
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

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = _resetEmailController.text.trim();
              if (email.isEmpty) return;
              _authService.sendPasswordResetEmail(email);
              Navigator.pop(ctx);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _formChildren(),
    );
  }

  List<Widget> _formChildren() {
    final children = <Widget>[
      const SizedBox(height: 60),

      // Logo
      const Icon(Icons.restaurant_menu, size: 80, color: AppTheme.primaryColor),
      const SizedBox(height: 16),
      const Text(
        '食刻輕卡',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        _isRegisterMode ? '建立新帳號' : '登入你的帳號',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
      ),
      const SizedBox(height: 40),

      // Error
      if (_errorMessage != null) ...[
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: AppTheme.errorColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],

      // Guest button
      ElevatedButton(
        onPressed: _isLoading ? null : _guestSignIn,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primaryColor,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text('立即開始使用（免登入）', style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(height: 24),

      // Divider
      Row(children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('或', style: TextStyle(color: Colors.grey.shade600)),
        ),
        const Expanded(child: Divider()),
      ]),
      const SizedBox(height: 16),

      // Google
      OutlinedButton.icon(
        onPressed: _isLoading ? null : _googleSignIn,
        icon: const Icon(Icons.login),
        label: const Text('以 Google 登入'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      const SizedBox(height: 16),

      // Email
      TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 12),

      // Password
      TextField(
        controller: _passwordController,
        decoration: const InputDecoration(
          labelText: '密碼',
          prefixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
      ),
    ];

    // Confirm password (register mode only)
    if (_isRegisterMode) {
      children.addAll([
        const SizedBox(height: 12),
        TextField(
          controller: _confirmController,
          decoration: const InputDecoration(
            labelText: '確認密碼',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
      ]);
    }

    children.addAll([
      const SizedBox(height: 24),

      // Submit
      ElevatedButton(
        onPressed: _isLoading
            ? null
            : (_isRegisterMode ? _emailRegister : _emailSignIn),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(_isRegisterMode ? '註冊' : '登入'),
      ),
      const SizedBox(height: 12),

      // Toggle / forgot
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
              onPressed: _showResetDialog,
              child: const Text('忘記密碼？'),
            ),
        ],
      ),
      const SizedBox(height: 24),

      // Firebase hint
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Firebase 設定完成後即可使用 Google 登入與雲端同步',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    ]);

    return children;
  }
}
