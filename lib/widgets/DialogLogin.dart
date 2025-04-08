import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/User.dart';
import '../models/constants/ColorConstants.dart';

class DialogLogin extends StatefulWidget {
  final Function callback;

  const DialogLogin({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => DialogLoginState(callback: callback);
}

class DialogLoginState extends State<DialogLogin> {
  DialogLoginState({
    required this.callback,
  });

  bool executingCall = false;

  Function callback = (User user) => {};

  String emailOrUsername = '';

  String password = '';

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(ColorConstants.my_dark_grey),
      child: SingleChildScrollView( // Make the scrollable area take the full available space
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Align items in the center
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make them stretch to fit width
            children: [
              // Email/Username input
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  emailOrUsername = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email or username',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16), // Add spacing between fields

              // Password input
              TextField(
                style: const TextStyle(color: Colors.white),
                obscureText: obscureText,
                onChanged: (text) {
                  password = text;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Your password',
                  hintStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText; // Toggle password visibility
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add spacing between fields

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () {
                    if (executingCall) {
                      return;
                    }
                    setState(() {
                      executingCall = true;
                    });
                    loginWith(emailOrUsername, password);
                  },
                  child: executingCall
                      ? const CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.login),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginWith(String emailOrUsername, String password) async {
    if (emailOrUsername.length < 5) {

      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Text('Username must be at least 5 characters long'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });

      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Text('Invalid username or password'), showCloseIcon: true, duration: Duration(seconds: 5),
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
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
            (userFromServer == null)
              ? 'User not found'
              : userFromServer.errorMessage.isEmpty
              ? 'Login failed server error'
              : userFromServer.errorMessage,),
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
