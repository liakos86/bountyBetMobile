
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';

class DialogRegister extends StatefulWidget {

  Function callback = (User user) => {};

  DialogRegister({required this.callback});

  @override
  State<StatefulWidget> createState() => DialogRegisterState(callback: callback);
}

class DialogRegisterState extends State<DialogRegister> {

  DialogRegisterState({
    required this.callback
  });

  bool executingCall = false;

  Function callback = (User user) => {};

  String errorMsg = '';

  String email = '';

  String password = '';

  String username = '';

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(ColorConstants.my_dark_grey),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Email input field
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  email = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'your email',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 2), // Add spacing between fields

              // Username input field
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  username = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'your username',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 2), // Add spacing between fields

              // Password input field with visibility toggle
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
              const SizedBox(height: 4), // Add spacing between fields

              // Register button
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
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500),
                  ),
                  onPressed: () {
                    if (executingCall) {
                      return;
                    }

                    setState(() {
                      executingCall = true;
                    });

                    registerWith(email, password, username);
                  },
                  child: executingCall
                      ? const CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.register),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }

  void registerWith(String email, String password, String username) async {

    String? userError = validateUsername(username);
    if (userError != null) {

      ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
        content: Text(userError), showCloseIcon: true, duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });

      return;
    }

    String? emailError = validateEmail(email);
    if (emailError != null) {

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text(emailError), showCloseIcon: true, duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });

      return;
    }

    String? passError = validatePassword(password);
    if (passError != null) {

      ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
        content: Text(passError), showCloseIcon: true, duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
      });

      return;
    }


      User? userFromServer = await HttpActionsClient.register(username, email, password);

    if (userFromServer != null) {
      if (userFromServer.errorMessage != Constants.empty) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(userFromServer.errorMessage), showCloseIcon: true, duration: const Duration(seconds: 5),
        ));

        setState(() {
          executingCall = false;
        });

        return;
      }
    }

    if (userFromServer == null){

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration failed'),
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

  String? validatePassword(String password) {
    // Check length
    if (password.length < 6 || password.length > 12) {
      return "Password must be between 6 and 12 characters long.";
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number.";
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character.";
    }

    return null; // Valid password
  }

  String? validateEmail(String email) {
    // Regular expression for validating email
    String pattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);

    if (email.isEmpty) {
      return "Email cannot be empty.";
    } else if (!regex.hasMatch(email)) {
      return "Enter a valid email address.";
    }

    return null; // Valid email
  }

  String? validateUsername(String username) {
    // Check length
    if (username.length < 6 || username.length > 18) {
      return "Username must be between 6 and 18 characters long.";
    }

    // Check if it contains only letters and numbers
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return "Username can only contain letters and numbers.";
    }

    return null; // Valid username
  }


}

