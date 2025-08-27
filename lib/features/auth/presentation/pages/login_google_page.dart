import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginGooglePage extends StatefulWidget {
  @override
  State<LoginGooglePage> createState() => _AppScreenState();
}

class _AppScreenState extends State<LoginGooglePage> {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId: '51223296662-ne0gbne5a20n4rtenpj6und3i4u077m8.apps.googleusercontent.com',
            scopes: ['email', 'profile'],
          )
        : GoogleSignIn(scopes: ['email', 'profile']);
  }

  void _signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Người dùng hủy đăng nhập

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
              print(GoogleSignInAuthentication);
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