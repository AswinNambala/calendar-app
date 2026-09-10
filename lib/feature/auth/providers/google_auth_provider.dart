import 'package:calendar_app/feature/auth/data/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider implements SocailAuthProviders {
  GoogleSignInProvider(this._googleSignIn);
 
  final GoogleSignIn _googleSignIn;
  bool _initialized = false;
 
  @override
  String get providerId => 'google';
 
  @override
  Future<fb_auth.AuthCredential> authenticate() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
 
    if (!_googleSignIn.supportsAuthenticate()) {
      throw fb_auth.FirebaseAuthException(
        code: 'platform-not-supported',
        message: 'This platform does not support Google sign-in',
      );
    }
 
    final googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;
    final authorization = await googleUser.authorizationClient
        .authorizationForScopes(['email']);
 
    return fb_auth.GoogleAuthProvider.credential(
      accessToken: authorization?.accessToken,
      idToken: idToken,
    );
  }
 
  @override
  Future<void> signOut() => _googleSignIn.signOut();
}