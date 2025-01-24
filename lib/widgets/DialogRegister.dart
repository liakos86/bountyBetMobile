import 'dart:convert';

import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';

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

          Text(errorMsg, style: const TextStyle(color: Colors.red),),

          TextField(
            style: const TextStyle(color: Colors.white),
            controller: null,
            onChanged: (text) {
              this.email = text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your email',
              hintStyle:  TextStyle(color: Colors.white),
            ),
          ),

          TextField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            controller: null,
            onChanged: (text) {
              this.username = text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your username',
              hintStyle:  TextStyle(color: Colors.white),
            ),
          ),

          TextField(
            style: const TextStyle(color: Colors.white),
            controller: null,
            onChanged: (text) {
              this.password = text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your password',
              hintStyle:  TextStyle(color: Colors.white),
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

              registerWith(email, password, username);
            },
            child: executingCall ? const CircularProgressIndicator() :  Text(AppLocalizations.of(context)!.register),
          )
    )
      // )
      ])
        // ],
// ])
      )));
  }

  void registerWith(String email, String password, String username) async {
    if (username.length < 5 ) {

      Fluttertoast.showToast(msg: 'Invalid username', toastLength: Toast.LENGTH_LONG);
      setState(() {
        executingCall = false;
        // errorMsg = 'Invalid username';
      });

      return;
    }

    if (email.length < 5 ||
        !email.contains('@gmail.com') ) {

      Fluttertoast.showToast(msg: 'Invalid email', toastLength: Toast.LENGTH_LONG);

      setState(() {
        executingCall = false;
        // errorMsg = 'Invalid email';
      });

      return;
    }

    if (password.length < 8) {

      Fluttertoast.showToast(msg: 'Invalid password', toastLength: Toast.LENGTH_LONG);
      setState(() {
        executingCall = false;
        // errorMsg = 'Invalid password';
      });

      return;
    }


      User? userFromServer = await HttpActionsClient.register(username, email, password);

    if (userFromServer != null) {
      if (userFromServer.errorMessage != Constants.empty) {
        Fluttertoast.showToast(msg: userFromServer.errorMessage, toastLength: Toast.LENGTH_LONG);
        setState(() {
          executingCall = false;
          // errorMsg = userFromServer.errorMessage;
        });

        return;
      }
    }

    if (userFromServer == null){
      Fluttertoast.showToast(msg: 'Registration failed', toastLength: Toast.LENGTH_LONG);
      setState(() {
        executingCall = false;
        // errorMsg = userFromServer.errorMessage;
      });

      return;
    }

      callback.call(userFromServer);

  }

}

