import 'package:flutter/material.dart';
import 'package:my_app/features/homepage/home_page.dart';
import 'package:my_app/features/auth/presentation/pages/login_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String methodLogin = '/methodLogin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text("Not Found"))));
    }
  }
}