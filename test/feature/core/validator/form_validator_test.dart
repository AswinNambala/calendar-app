import 'package:calendar_app/core/validators/form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormValidators.emailValidator', () {
    test('null returns empty-field message', () {
      expect(
        FormValidators.emailValidator(null),
        'Email field cannot be empty',
      );
    });

    test('empty string returns empty-field message', () {
      expect(
        FormValidators.emailValidator(''),
        'Email field cannot be empty',
      );
    });

    test('whitespace-only string returns empty-field message', () {
      expect(
        FormValidators.emailValidator('    '),
        'Email field cannot be empty',
      );
    });

    test('missing @ returns invalid message', () {
      expect(
        FormValidators.emailValidator('userexample.com'),
        'Enter a valid email',
      );
    });

    test('missing domain returns invalid message', () {
      expect(FormValidators.emailValidator('user@'), 'Enter a valid email');
    });

    test('missing TLD returns invalid message', () {
      expect(
        FormValidators.emailValidator('user@example'),
        'Enter a valid email',
      );
    });

    test('space inside address returns invalid message', () {
      expect(
        FormValidators.emailValidator('user name@example.com'),
        'Enter a valid email',
      );
    });

    test('valid simple email returns null', () {
      expect(FormValidators.emailValidator('user@example.com'), isNull);
    });

    test('valid email with dots and subdomain returns null', () {
      expect(
        FormValidators.emailValidator('first.last@mail.example.co'),
        isNull,
      );
    });

    test('leading/trailing whitespace is trimmed before validation', () {
      expect(FormValidators.emailValidator('  user@example.com  '), isNull);
    });

    test('uppercase email is accepted', () {
      expect(FormValidators.emailValidator('USER@EXAMPLE.COM'), isNull);
    });
  });

  group('FormValidators.passwordValidator', () {
    test('null returns must-enter message', () {
      expect(
        FormValidators.passwordValidator(null),
        'Must enter a password',
      );
    });

    test('empty string returns must-enter message', () {
      expect(FormValidators.passwordValidator(''), 'Must enter a password');
    });

    test('5 characters returns too-short message', () {
      expect(
        FormValidators.passwordValidator('abcde'),
        'Password must be at least 6 characters',
      );
    });

    test('exactly 6 characters is accepted (boundary)', () {
      expect(FormValidators.passwordValidator('abcdef'), isNull);
    });

    test('long password is accepted', () {
      expect(
        FormValidators.passwordValidator('a-very-long-password-123'),
        isNull,
      );
    });

    test('trailing space counts toward length since input is not trimmed', () {
      expect(FormValidators.passwordValidator('abcde '), isNull);
    });

    test('whitespace-only 6-char string is accepted (no trim logic)', () {
      expect(FormValidators.passwordValidator('      '), isNull);
    });
  });
}