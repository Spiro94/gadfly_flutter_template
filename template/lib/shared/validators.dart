import 'package:email_validator/email_validator.dart';

/// https://github.com/fredeil/email-validator.dart
bool isEmailValid(String email) => EmailValidator.validate(email);
