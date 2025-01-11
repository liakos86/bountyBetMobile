import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/User.dart';

class DialogLogin extends StatefulWidget {



  Function callback = (User user) => {};

  DialogLogin({required this.callback});

  @override
  State<StatefulWidget> createState() => DialogLoginState(callback: callback);
}


  class DialogLoginState extends State<DialogLogin>{

  DialogLoginState({
    required this.callback
  });

    Function callback = (User user) => {};

    String emailOrUsername = '';

    String password = '';

    String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return
      Padding(padding: const EdgeInsets.all(6),
    child:


    SingleChildScrollView(
    child:

    Column(children:[

        Text(errorMsg, style: const TextStyle(color: Colors.red)),

        TextField(
          controller: null,
          onChanged: (text){
            emailOrUsername = text;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email or username',
          ),
        ),

        TextField(

          obscureText: true,
          controller: null,
          onChanged: (text){
            password = text;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your password',
          ),
        ),



    SizedBox(
    width: double.infinity,
    child:
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Colors.black)
                  )
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
          ),
          onPressed: () {
            loginWith(emailOrUsername, password);
          },
          child: Text(AppLocalizations.of(context)!.login),
        )
    )
      ],
    ))

    );
  }

  void loginWith(String emailOrUsername, String password) async{
      if (emailOrUsername.length < 5 ){

        setState(() {
          errorMsg = 'Username must be at least 5 characters long';
        });

        return;
      }

      if (password.isEmpty ){

        setState(() {
          errorMsg = 'Invalid username or password';
        });

        return;
      }

     User? userFromServer = await HttpActionsClient.loginUser(emailOrUsername, password);
      if (userFromServer != null && userFromServer.errorMessage.isEmpty) {
        callback.call(userFromServer);
      }else {
        setState(() {
          errorMsg = userFromServer == null || userFromServer.errorMessage.isEmpty ? 'Login failed server error' : userFromServer.errorMessage;
        });
      }
    }
}