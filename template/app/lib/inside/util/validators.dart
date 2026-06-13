import 'package:email_validator/email_validator.dart';

class InsideUtil_Validators {
  static bool isEmailValid(String value) {
    return EmailValidator.validate(value);
  }

  /// https: //stackoverflow.com/questions/68226712/how-to-check-if-string-contains-both-uppercase-and-lowercase-characters
  static bool isPasswordValid(String password) => RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  ).hasMatch(password);
}
