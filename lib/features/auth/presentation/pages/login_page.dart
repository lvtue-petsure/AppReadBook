import 'package:flutter/material.dart';
import 'package:my_app/features/auth/presentation/pages/register_page.dart';
import 'package:my_app/features/homepage/home_page.dart';
import 'package:my_app/features/auth/presentation/pages/login_google_page.dart';
import 'package:my_app/features/auth/dbService/supabase_service.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  String errorMessage ="";
  bool _obscure = true;
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = _emailC.text.trim();
    final pass = _passC.text.trim();
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    setState(() => _loading = true);
    final supabaseService = SupabaseService();
    final login = await supabaseService.loginUser(user,pass);
    if (login){
      setState(() => _loading = false);
       Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',       // route tới HomePage
      (route) => false, // xóa toàn bộ các route trước đó (kể cả login)
    );
    }else{
        setState(() => _loading = false);
        errorMessage = "Sai tài khoản hoặc mật khẩu";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.05, 0.35, 0.7, 1.0],
                colors: [
                  Color(0xFF1A237E), // indigo[900]
                  Color(0xFF3949AB),
                  Color(0xFF5C6BC0),
                  Color(0xFF8E99F3),
                ],
              ),
            ),
          ),
          Positioned(
            top: -40,
            left: -40,
            child: _blurBall(160),
          ),
          Positioned(
            bottom: -20,
            right: -20,
            child: _blurBall(220),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                         child:  Column(
                          children: [
                            if (errorMessage !=null)
                            Text(
                              errorMessage,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(Icons.lock_outline_rounded, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Chào mừng trở lại 👋',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Opacity(
                              opacity: 0.85,
                              child: Text(
                                'Đăng nhập để tiếp tục',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                )
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email
                            TextFormField(
                              controller: _emailC,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username, AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              validator: (v) {
                                final s = (v ?? '').trim();
                                if (s.isEmpty) return 'Vui lòng nhập tài khoản';
                              },
                            ),
                            const SizedBox(height: 14),

                            // Password
                            TextFormField(
                              controller: _passC,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                                  tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                                ),
                              ),
                              validator: (v) {
                                final s = (v ?? '');
                                if (s.isEmpty) return 'Vui lòng nhập mật khẩu';
                                if (s.length < 6) return 'Ít nhất 6 ký tự';
                                return null;
                              },
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                onPressed: _loading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text('Đăng nhập'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                const Expanded(child: Divider(height: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      'hoặc',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(height: 1)),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _loading
                                        ? null
                                        : () => Navigator.push( context,
                                            MaterialPageRoute(builder: (context) => LoginGooglePage()),
                                          ),
                                    icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.blue),
                                    label: const SelectableText('GOOGLE', style: TextStyle(color: Colors.white, fontSize: 10,  fontWeight: FontWeight.bold, )),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Opacity(
                              opacity: 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Chưa có tài khoản? "),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                                      );
                                    },
                                    child: const Text('Đăng ký ngay',style: TextStyle(color: Colors.while),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height < 700 ? 6 : 18,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.8,
              child: Text(
                '© ${DateTime.now().year} Your Company',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _blurBall(double size) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
        ),
      ),
    );
  }
}