import 'package:calendar_app/feature/auth/data/auth_providers.dart';
import 'package:calendar_app/feature/auth/providers/google_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthRepository {
  AuthRepository(this._firebaseAuth, this._googleAuthProvider);

  final fb_auth.FirebaseAuth _firebaseAuth;
  final SocailAuthProviders _googleAuthProvider;

  Stream<fb_auth.User?> authStateChanges() => _firebaseAuth.authStateChanges();

  fb_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<fb_auth.UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb_auth.UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb_auth.UserCredential> signInWithGoogle() async {
    final credential = await _googleAuthProvider.authenticate();
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleAuthProvider.signOut();
    await _firebaseAuth.signOut();
  }
}

// --- Providers ---

final firebaseAuthProvider = Provider<fb_auth.FirebaseAuth>((ref) {
  return fb_auth.FirebaseAuth.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

final googleAuthProviderImplProvider = Provider<SocailAuthProviders>((ref) {
  return GoogleSignInProvider(ref.watch(googleSignInProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleAuthProviderImplProvider),
  );
});

final authStateChangesProvider = StreamProvider<fb_auth.User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
