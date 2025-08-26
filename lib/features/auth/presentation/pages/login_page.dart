import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

   void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // TODO: gọi API login qua auth repository
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login success!")),
        );
      });
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.brown[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Đăng nhập",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Tài Khoản",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Nhập Tài Khoản" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Mật khẩu",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Nhập Mật khẩu" : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Đăng nhập"),
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // TODO: chuyển sang register
                      },
                      child: const Text("Chưa có tài khoản? Đăng ký"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}