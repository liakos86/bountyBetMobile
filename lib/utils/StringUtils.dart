import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StringUtils{

  static bool validateEmail(String email) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);

    if (email.isEmpty || !regex.hasMatch(email)) {
      return false;
    }

    return true;
  }

  static String? validatePassword(String password, String passwordRepeat, BuildContext context) {
    if (password.length < 6 || password.length > 12) {
      return AppLocalizations.of(context)!.validation_password_length;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return AppLocalizations.of(context)!.validation_password_number;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return AppLocalizations.of(context)!.validation_password_special;
    }

    if (passwordRepeat != password) {
      return AppLocalizations.of(context)!.password_repeat_missmatch;
    }

    return null;
  }

  static String? validateUsername(String username, BuildContext context) {
    if (username.length < 6 || username.length > 18) {
      return AppLocalizations.of(context)!.validation_invalid_username_length;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return AppLocalizations.of(context)!.validation_invalid_username_char;
    }

    return null;
  }


}