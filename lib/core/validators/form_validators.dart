// validator function
// for firebase validating email and password for customs checks
class FormValidators {
 static String? emailValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email field cannot be empty';
    }
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Must enter a password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
