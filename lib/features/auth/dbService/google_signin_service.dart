// google_signin_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleSignInService {
  static final GoogleSignIn googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId: '51223296662-ne0gbne5a20n4rtenpj6und3i4u077m8.apps.googleusercontent.com',
          scopes: ['email', 'profile'],
        )
      : GoogleSignIn(scopes: ['email', 'profile']);
}
