import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGooglePage extends StatefulWidget {
  @override
  State<LoginGooglePage> createState() => _AppScreenState();
}

class _AppScreenState extends State<LoginGooglePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  void _signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Người dùng hủy đăng nhập

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // final user = userCredential.user;

      // // Lưu vào bảng (Firestore)
      // if (user != null) {
       
      // }

      //return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

   void _signOut() async {
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
        child: _user == null
            ? ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign in with Google'),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user!.photoUrl ?? ''),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text('Hello, ${_user!.displayName}'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}