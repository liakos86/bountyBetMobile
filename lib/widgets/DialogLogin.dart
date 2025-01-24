import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../models/User.dart';
import '../models/constants/ColorConstants.dart';

class DialogLogin extends StatefulWidget {

  late final Function callback;

  DialogLogin({required this.callback});

  @override
  State<StatefulWidget> createState() => DialogLoginState(callback: callback);
}


  class DialogLoginState extends State<DialogLogin>{

  DialogLoginState({
    required this.callback
  });

  bool executingCall = false;

    Function callback = (User user) => {};

    String emailOrUsername = '';

    String password = '';

    // String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return

    Container(
    color: const Color(ColorConstants.my_dark_grey),
      child:
      Padding(padding: const EdgeInsets.all(6),
      child:
    SingleChildScrollView(
    child:

    Column(children:[

        //Text(errorMsg, style: const TextStyle(color: Colors.red)),

        TextField(
          style: const TextStyle(color: Colors.white),
          controller: null,
          onChanged: (text){
            emailOrUsername = text;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email or username',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),

        TextField(

          style: const TextStyle(color: Colors.white),
          obscureText: true,
          controller: null,
          onChanged: (text){
            password = text;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your password',
            hintStyle: TextStyle(color: Colors.white),
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
            if (executingCall){
              return;
            }


            setState(() {
              executingCall = true;
            });

            loginWith(emailOrUsername, password);
          },
          child: executingCall ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.login),
        )
    )
      ],
    ))

    )
    );
  }

  void loginWith(String emailOrUsername, String password) async{
      if (emailOrUsername.length < 5 ){

        Fluttertoast.showToast(msg: 'Username must be at least 5 characters long', toastLength: Toast.LENGTH_LONG);

        setState(() {
          executingCall = false;
          // errorMsg = 'Username must be at least 5 characters long';
        });

        return;
      }

      if (password.isEmpty ){

        Fluttertoast.showToast(msg: 'Invalid username or password', toastLength: Toast.LENGTH_LONG);
        setState(() {
          executingCall = false;
          // errorMsg = 'Invalid username or password';
        });

        return;
      }

     User? userFromServer = await HttpActionsClient.loginUser(emailOrUsername, password);
      if (userFromServer != null && userFromServer.errorMessage.isEmpty) {
        callback.call(userFromServer);
      }else {

        Fluttertoast.showToast(msg: userFromServer == null ? 'User not found' :  userFromServer.errorMessage.isEmpty ? 'Login failed server error' : userFromServer.errorMessage, toastLength: Toast.LENGTH_LONG);
        setState(() {
          executingCall = false;
          // errorMsg = userFromServer == null ? 'User not found' :  userFromServer.errorMessage.isEmpty ? 'Login failed server error' : userFromServer.errorMessage;
        });
      }
    }
}