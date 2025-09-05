import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/User.dart';

class DialogForgotPass extends StatefulWidget {
  // final Function callback;

  const DialogForgotPass({super.key, });

  @override
  State<StatefulWidget> createState() => DialogForgotPassState();
}

class DialogForgotPassState extends State<DialogForgotPass> {
  DialogForgotPassState();

  bool executingCall = false;

  bool passReset = false;

  // Function callback = (User user) => {};

  String email = '';

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

                      passReset ?

                          Text('Password reset mail sent to $email', style: const TextStyle(color: Colors.green, fontSize: 18)) :

                      TextField(
                        style: const TextStyle(color: Colors.black),
                        onChanged: (text) {
                          email = text;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'email',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 16),

                    ],
                  ),
                ),

                // Login Button fixed to bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child:

                    passReset ? SizedBox() :

                    ElevatedButton(
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
                        resetPasswordFor(email);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetPasswordFor(String emailInput) async {
    String? emailError = validateEmail(emailInput);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(emailError),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),
      ));

      setState(() {
        executingCall = false;
        passReset = true;
      });
      return;
    }

    String? emailResponse = await HttpActionsClient.forgotPasswordClaim(emailInput);
    if (emailResponse == null)  {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Could not reset password"),
          showCloseIcon: true,
          duration: Duration(seconds: 5),
        ));
      }


    }

    setState(() {
      executingCall = false;
      passReset = true;
    });
  }

  String? validateEmail(String email) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);

    if (email.isEmpty || !regex.hasMatch(email)) {
      return AppLocalizations.of(context)!.validation_invalid_email;
    }

    return null;
  }
}
