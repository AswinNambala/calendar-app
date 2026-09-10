import 'package:firebase_auth/firebase_auth.dart';

abstract class SocailAuthProviders {
  String get providerId;
  Future<AuthCredential> authenticate();
  Future<void> signOut() async {}
}
