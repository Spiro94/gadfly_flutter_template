import 'package:email_validator/email_validator.dart';

/// https://github.com/fredeil/email-validator.dart
bool isEmailValid(String email) => EmailValidator.validate(email);

/// https: //stackoverflow.com/questions/68226712/how-to-check-if-string-contains-both-uppercase-and-lowercase-characters
bool isPasswordValid(String password) =>
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
