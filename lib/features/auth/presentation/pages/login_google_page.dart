import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginGooglePage extends StatefulWidget {
  @override
  State<LoginGooglePage> createState() => _LoginGooglePageState();
}

class _LoginGooglePageState extends State<LoginGooglePage> {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId:
                '51223296662-ne0gbne5a20n4rtenpj6und3i4u077m8.apps.googleusercontent.com',
            scopes: ['email', 'profile'],
          )
        : GoogleSignIn(scopes: ['email', 'profile']);
  }

  Future<void> _signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // Người dùng hủy đăng nhập

      setState(() {
        _user = googleUser;
      });
       if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',       // route đã khai báo trong MaterialApp
          (route) => false, // clear hết stack
        );
      }
          
    } catch (e) {
      print("Sign in error: $e");
    }
  }

  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center(
        child:
        ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign in with Google'),
              )       
      ),
    );
  }
}
