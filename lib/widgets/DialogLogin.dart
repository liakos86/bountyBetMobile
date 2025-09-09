import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/context/AppContext.dart';
import '../utils/StringUtils.dart';

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


  String emailReset = '';
  String passwordOldReset = '';
  String passwordReset = '';
  String passwordResetRepeat = '';
  bool obscureTextReset = true;
  bool obscureTextResetRepeat = true;

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

                AppContext.user.passwordReset ?

                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    TextField(
                      key: const PageStorageKey<String>(
                          'emailReset'),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (text) {
                        emailReset = text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'email',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: false,
                      onChanged: (text) {
                        passwordOldReset = text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'temp password (check email inbox)',
                        hintStyle: TextStyle(color: Colors.black54),
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     obscureText ? Icons.visibility_off : Icons.visibility,
                        //     color: Colors.black,
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       obscureText = !obscureText;
                        //     });
                        //   },
                        // ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: obscureTextReset,
                      onChanged: (text) {
                        passwordReset = text;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.password,
                        hintStyle: const TextStyle(color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureTextReset ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureTextReset = !obscureTextReset;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Repeat Password
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: obscureTextResetRepeat,
                      onChanged: (text) {
                        passwordResetRepeat = text;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.password_repeat,
                        hintStyle: const TextStyle(color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureTextResetRepeat ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureTextResetRepeat = !obscureTextResetRepeat;
                            });
                          },
                        ),
                      ),
                    ),

                  ]
                  )
                )

                :

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


                AppContext.user.passwordReset ?
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
                        changePassWith(emailReset, passwordOldReset, passwordReset, passwordResetRepeat);
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
                          : Text(AppLocalizations.of(context)!.password_reset),
                    ),
                  ),
                )

                :
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

    User? userFromServer = await HttpActionsClient.loginUser(emailOrUsername, password);
    if (userFromServer.errorMessage.isEmpty) {

      if (userFromServer.passwordReset){
        setState(() {
          executingCall = false;
          AppContext.user.passwordReset = true;
        });
        return;
      }else {
        callback.call(userFromServer);
      }

    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(userFromServer.errorMessage.isEmpty
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

  Future<void> changePassWith(String emailReset, String passwordOldReset, String passwordReset, String passwordResetRepeat) async{
    bool emailValid = StringUtils.validateEmail(emailReset);
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

    String? passError = StringUtils.validatePassword(passwordReset, passwordResetRepeat, context);
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

    User? userFromServer = await HttpActionsClient.forgotPasswordSelectNew(emailReset, passwordOldReset, passwordReset);

    if (userFromServer.mongoUserId != Constants.defMongoId && userFromServer.errorMessage != Constants.empty) {
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

    if (userFromServer.errorMessage.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password reset failed'),
          showCloseIcon: true,
          duration: Duration(seconds: 5),
        ));
      }

      setState(() {
        executingCall = false;
      });
      return;
    }

    callback.call(userFromServer);
  }
}
