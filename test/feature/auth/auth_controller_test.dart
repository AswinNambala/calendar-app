import 'package:calendar_app/feature/auth/application/auth_controller.dart';
import 'package:calendar_app/feature/auth/data/auth_respository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements fb_auth.UserCredential {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthController controller;

  setUp(() {
    mockRepository = MockAuthRepository();
    controller = AuthController(mockRepository);
  });

  tearDown(() {
    controller.dispose();
  });

  test('initial state is AsyncData(null)', () {
    expect(controller.state, const AsyncData<void>(null));
  });

  group('signInWithEmail', () {
    test('returns true and settles to AsyncData on success', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockRepository.signInWithEmail(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);

      final result = await controller.signInWithEmail(
        email: 'user@example.com',
        password: 'password1',
      );

      expect(result, isTrue);
      expect(controller.state.hasError, isFalse);
      expect(controller.state, isA<AsyncData<void>>());
      verify(
        () => mockRepository.signInWithEmail(
          email: 'user@example.com',
          password: 'password1',
        ),
      ).called(1);
    });

    test(
      'returns false and settles to AsyncError on repository failure',
      () async {
        final exception = fb_auth.FirebaseAuthException(
          code: 'wrong-password',
          message: 'The password is invalid.',
        );
        when(
          () => mockRepository.signInWithEmail(
            email: any<String>(named: 'email'),
            password: any<String>(named: 'password'),
          ),
        ).thenThrow(exception);

        final result = await controller.signInWithEmail(
          email: 'user@example.com',
          password: 'wrongpass',
        );

        expect(result, isFalse);
        expect(controller.state.hasError, isTrue);
        expect(controller.state.error, exception);
      },
    );

    test('emits AsyncLoading before settling', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockRepository.signInWithEmail(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return credential;
      });

      final expectation = expectLater(
        controller.stream,
        emitsInOrder([isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]),
      );

      await controller.signInWithEmail(
        email: 'user@example.com',
        password: 'password1',
      );

      await expectation;
    });

    test(
      'empty email/password are still forwarded to the repository as-is',
      () async {
        final fb_auth.UserCredential credential = MockUserCredential();
        when(
          () => mockRepository.signInWithEmail(
            email: any<String>(named: 'email'),
            password: any<String>(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);

        await controller.signInWithEmail(email: '', password: '');

        verify(
          () => mockRepository.signInWithEmail(email: '', password: ''),
        ).called(1);
      },
    );
  });

  group('signUpWithEmail', () {
    test('returns true on success', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockRepository.signUpWithEmail(
          email: any<String>(named: 'email'),
          password: any<String>(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);

      final result = await controller.signUpWithEmail(
        email: 'new@example.com',
        password: 'password1',
      );

      expect(result, isTrue);
    });

    test(
      'returns false and carries the error code when email is in use',
      () async {
        when(
          () => mockRepository.signUpWithEmail(
            email: any<String>(named: 'email'),
            password: any<String>(named: 'password'),
          ),
        ).thenThrow(
          fb_auth.FirebaseAuthException(code: 'email-already-in-use'),
        );

        final result = await controller.signUpWithEmail(
          email: 'existing@example.com',
          password: 'password1',
        );

        expect(result, isFalse);
        expect(
          (controller.state.error as fb_auth.FirebaseAuthException).code,
          'email-already-in-use',
        );
      },
    );
  });

  group('signInWithGoogle', () {
    test('returns true on success', () async {
      final fb_auth.UserCredential credential = MockUserCredential();
      when(
        () => mockRepository.signInWithGoogle(),
      ).thenAnswer((_) async => credential);

      final result = await controller.signInWithGoogle();

      expect(result, isTrue);
      verify(() => mockRepository.signInWithGoogle()).called(1);
    });

    test('returns false when the platform is unsupported', () async {
      when(() => mockRepository.signInWithGoogle()).thenThrow(
        fb_auth.FirebaseAuthException(code: 'platform-not-supported'),
      );

      final result = await controller.signInWithGoogle();

      expect(result, isFalse);
    });

    test('returns false on an unexpected non-Firebase error', () async {
      when(
        () => mockRepository.signInWithGoogle(),
      ).thenThrow(Exception('network down'));

      final result = await controller.signInWithGoogle();

      expect(result, isFalse);
      expect(controller.state.hasError, isTrue);
    });
  });

  group('signOut', () {
    test('settles to AsyncData(null) on success', () async {
      when(() => mockRepository.signOut()).thenAnswer((_) async {});

      await controller.signOut();

      expect(controller.state, const AsyncData<void>(null));
      verify(() => mockRepository.signOut()).called(1);
    });

    test('settles to AsyncError when the repository throws', () async {
      when(
        () => mockRepository.signOut(),
      ).thenThrow(Exception('sign out failed'));

      await controller.signOut();

      expect(controller.state.hasError, isTrue);
    });
  });
}
