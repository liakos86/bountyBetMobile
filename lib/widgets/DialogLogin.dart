import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/User.dart';

class DialogLogin extends StatefulWidget {
  final Function callback;

  const DialogLogin({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => DialogLoginState(callback: callback);
}

class DialogLoginState extends State<DialogLogin> {
  DialogLoginState({required this.callback});

  bool executingCall = false;

  Function callback = (User user) => {};

  String emailOrUsername = '';
  String password = '';

  bool obscureText = true;

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email or Username
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        onChanged: (text) {
                          emailOrUsername = text;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: AppLocalizations.of(context)!.email_or_username,
                          hintStyle: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 16),

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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Login Button fixed to bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      onPressed: executingCall
                          ? null
                          : () {
                        setState(() {
                          executingCall = true;
                        });
                        loginWith(emailOrUsername, password);
                      },
                      child: executingCall
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(AppLocalizations.of(context)!.login),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginWith(String emailOrUsername, String password) async {
    if (emailOrUsername.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.validation_username),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.validation_invalid_username),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });
      return;
    }

    User? userFromServer =
    await HttpActionsClient.loginUser(emailOrUsername, password);
    if (userFromServer != null && userFromServer.errorMessage.isEmpty) {
      callback.call(userFromServer);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text((userFromServer == null)
              ? AppLocalizations.of(context)!.validation_invalid_username
              : userFromServer.errorMessage.isEmpty
              ? AppLocalizations.of(context)!.validation_invalid_username
              : userFromServer.errorMessage),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
        ));
      }

      setState(() {
        executingCall = false;
      });
    }
  }
}
