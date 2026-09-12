import 'package:calendar_app/feature/auth/application/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('authErrorMessage', () {
    test('user-not-found', () {
      final e = FirebaseAuthException(code: 'user-not-found');
      expect(authErrorMessage(e), 'No account found for that email.');
    });

    test('wrong-password', () {
      final e = FirebaseAuthException(code: 'wrong-password');
      expect(authErrorMessage(e), 'Incorrect email or password.');
    });

    test('invalid-credential maps to the same message as wrong-password', () {
      final e = FirebaseAuthException(code: 'invalid-credential');
      expect(authErrorMessage(e), 'Incorrect email or password.');
    });

    test('email-already-in-use', () {
      final e = FirebaseAuthException(code: 'email-already-in-use');
      expect(
        authErrorMessage(e),
        'An account already exists for that email.',
      );
    });

    test('weak-password', () {
      final e = FirebaseAuthException(code: 'weak-password');
      expect(authErrorMessage(e), 'Password is too weak.');
    });

    test('invalid-email', () {
      final e = FirebaseAuthException(code: 'invalid-email');
      expect(authErrorMessage(e), 'That email address looks invalid.');
    });

    test('platform-not-supported', () {
      final e = FirebaseAuthException(code: 'platform-not-supported');
      expect(
        authErrorMessage(e),
        'Google sign-in is not supported on this platform.',
      );
    });

    test('unknown code falls back to the exception message when present', () {
      final e = FirebaseAuthException(
        code: 'some-unmapped-code',
        message: 'A very specific Firebase error.',
      );
      expect(authErrorMessage(e), 'A very specific Firebase error.');
    });

    test('unknown code with null message falls back to generic text', () {
      final e = FirebaseAuthException(code: 'some-unmapped-code');
      expect(authErrorMessage(e), 'Something went wrong. Please try again.');
    });

    test('non-FirebaseAuthException error returns generic message', () {
      expect(
        authErrorMessage(Exception('random failure')),
        'Something went wrong. Please try again.',
      );
    });

    test('plain string error returns generic message', () {
      expect(
        authErrorMessage('just a string'),
        'Something went wrong. Please try again.',
      );
    });
  });
}