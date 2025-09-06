const String emailRegexPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String passwordRegexPattern =
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&._-])[A-Za-z\d@$!%*?&._-]{8,}$';
const String usernameRegexPattern = r'^[a-zA-Z0-9,.-]+$';

abstract class Validator {
  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(emailRegexPattern);
    if (val == null || val.trim().isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(val)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    final RegExp passwordRegex = RegExp(passwordRegexPattern);

    if (val == null || val.isEmpty) {
      return 'Password cannot be empty';
    } else if (val.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return 'Password must contain at least one uppercase letter (A–Z)';
    } else if (!RegExp(r'[a-z]').hasMatch(val)) {
      return 'Password must contain at least one lowercase letter (a–z)';
    } else if (!RegExp(r'\d').hasMatch(val)) {
      return 'Password must contain at least one number (0–9)';
    } else if (!RegExp(r'[@$!%*?&._-]').hasMatch(val)) {
      return 'Password must contain at least one special character (@, \$, !, %, *, ?, &, ., _, -)';
    } else if (!passwordRegex.hasMatch(val)) {
      return 'Password can only contain letters, numbers, and special characters (@, \$, !, %, *, ?, &, ., _, -)';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return 'Password cannot be empty';
    } else if (val != password) {
      return 'Confirm password must match the password';
    } else {
      return null;
    }
  }

  static String? validateName(String? val) {
    if (val == null || val.isEmpty) {
      return 'Name cannot be empty';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }

    final phone = val.trim();
    final isValid = RegExp(r'^\+?\d+$').hasMatch(phone);
    if (!isValid || phone.length != 13) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validateCode(String? val) {
    if (val == null || val.isEmpty) {
      return 'Code cannot be empty';
    } else if (val.length < 6) {
      return 'Code should be at least 6 digits';
    } else {
      return null;
    }
  }
}
