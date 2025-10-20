import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../utils/StringUtils.dart';

class DialogRegister extends StatefulWidget {
  Function callback = (User user) => {};

  DialogRegister({required this.callback});

  @override
  State<StatefulWidget> createState() => DialogRegisterState(callback: callback);
}

class DialogRegisterState extends State<DialogRegister> {
  DialogRegisterState({required this.callback});

  bool executingCall = false;

  Function callback = (User user) => {};

  String errorMsg = '';
  String email = '';
  String password = '';
  String passwordRepeat = '';
  String username = '';

  bool obscureText = true;
  bool obscureTextRepeat = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(4),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Email
                TextField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (text) {
                    email = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'email',
                    hintStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 8),

                // Username
                TextField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (text) {
                    username = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.username,
                    hintStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 8),

                // Password
                TextField(
                  style: const TextStyle(color: Colors.black),
                  obscureText: obscureText,
                  onChanged: (text) {
                    password = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.password,
                    hintStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Repeat Password
                TextField(
                  style: const TextStyle(color: Colors.black),
                  obscureText: obscureTextRepeat,
                  onChanged: (text) {
                    passwordRepeat = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.password_repeat,
                    hintStyle: const TextStyle(color: Colors.black54),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureTextRepeat ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureTextRepeat = !obscureTextRepeat;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      if (executingCall) return;

                      setState(() {
                        executingCall = true;
                      });

                      registerWith(email, password, username);
                    },
                    child: executingCall
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(AppLocalizations.of(context)!.register),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerWith(String email, String password, String username) async {
    String? userError = StringUtils.validateUsername(username, context);
    if (userError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(userError),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    bool emailValid = StringUtils.validateEmail(email);
    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.validation_invalid_email),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    String? passError = StringUtils.validatePassword(password, passwordRepeat, context);
    if (passError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(passError),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    User? userFromServer = await HttpActionsClient.register(username, email, password);

    if (userFromServer.errorMessage != Constants.empty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(userFromServer.errorMessage),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    callback.call(userFromServer);
  }

}
