import 'package:calendar_app/feature/auth/data/auth_providers.dart';
import 'package:calendar_app/feature/auth/data/auth_respository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements fb_auth.FirebaseAuth {}

class MockSocialAuthProviders extends Mock implements SocailAuthProviders {}

class MockUserCredential extends Mock implements fb_auth.UserCredential {}

class FakeAuthCredential extends Fake implements fb_auth.AuthCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockSocialAuthProviders mockGoogleProvider;
  late AuthRepository repository;

  setUpAll(() {
    // Required by mocktail whenever any<T>() is used with a custom
    // (non-primitive) class, e.g. AuthCredential below.
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleProvider = MockSocialAuthProviders();
    repository = AuthRepository(mockFirebaseAuth, mockGoogleProvider);
  });

  group('signInWithEmail', () {
    test('delegates to FirebaseAuth with the exact email/password', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);

      final result = await repository.signInWithEmail(
        email: 'user@example.com',
        password: 'password1',
      );

      expect(result, credential);
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'password1',
        ),
      ).called(1);
    });

    test('propagates FirebaseAuthException from FirebaseAuth', () {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenThrow(fb_auth.FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => repository.signInWithEmail(
          email: 'nobody@example.com',
          password: 'password1',
        ),
        throwsA(isA<fb_auth.FirebaseAuthException>()),
      );
    });
  });

  group('signUpWithEmail', () {
    test('delegates to FirebaseAuth.createUserWithEmailAndPassword', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);

      final result = await repository.signUpWithEmail(
        email: 'new@example.com',
        password: 'password1',
      );

      expect(result, credential);
    });
  });

  group('signInWithGoogle', () {
    test('exchanges the Google credential for a Firebase credential', () async {
      final fb_auth.AuthCredential googleCredential = FakeAuthCredential();
      final fb_auth.UserCredential userCredential = MockUserCredential();
      when(() => mockGoogleProvider.authenticate())
          .thenAnswer((_) async => googleCredential);
      when(() => mockFirebaseAuth.signInWithCredential(googleCredential))
          .thenAnswer((_) async => userCredential);

      final result = await repository.signInWithGoogle();

      expect(result, userCredential);
      verify(() => mockGoogleProvider.authenticate()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(googleCredential))
          .called(1);
    });

    test('propagates an error if Google authentication itself fails', () {
      when(() => mockGoogleProvider.authenticate())
          .thenThrow(Exception('user cancelled'));

      expect(() => repository.signInWithGoogle(), throwsException);
      verifyNever(
        () => mockFirebaseAuth.signInWithCredential(
          any<fb_auth.AuthCredential>(),
        ),
      );
    });
  });

  group('signOut', () {
    test('signs out of Google before signing out of Firebase', () async {
      final calls = <String>[];
      when(() => mockGoogleProvider.signOut()).thenAnswer((_) async {
        calls.add('google');
      });
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {
        calls.add('firebase');
      });

      await repository.signOut();

      expect(calls, ['google', 'firebase']);
    });

    test('propagates an error if Firebase signOut fails after Google signOut', () {
      when(() => mockGoogleProvider.signOut()).thenAnswer((_) async {});
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(Exception('network error'));

      expect(() => repository.signOut(), throwsException);
    });
  });
}