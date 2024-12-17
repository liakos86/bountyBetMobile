import 'dart:convert';

import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
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

  Function callback = (User user) => {};

  String errorMsg = '';

  String email = '';

  String password = '';

  String username = '';

  @override
  Widget build(BuildContext context) {

    return

    Padding(padding: const EdgeInsets.all(6),
      child:


      SingleChildScrollView(
         child:

             Column(children:[

          Text(errorMsg, style: const TextStyle(color: Colors.red),),

          TextField(
            controller: null,
            onChanged: (text) {
              this.email = text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your email',
            ),
          ),

          TextField(
            obscureText: true,
            controller: null,
            onChanged: (text) {
              this.username = text;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your username',
            ),
          ),

          TextField(
            controller: null,
            onChanged: (text) {
              this.password = text;
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

              registerWith(email, password, username);
            },
            child: Text(AppLocalizations.of(context)!.register),
          )
    )
      // )
      ])
        // ],
// ])
      ));
  }

  void registerWith(String email, String password, String username) async {
    if (username.length < 5 ) {

      setState(() {
        errorMsg = 'Invalid username';
      });

      return;
    }

    if (email.length < 5 ||
        !email.contains('@gmail.com') ) {

      setState(() {
        errorMsg = 'Invalid email';
      });

      return;
    }

    if (password.length < 8) {

      setState(() {
        errorMsg = 'Invalid password';
      });

      return;
    }


      User? userFromServer = await HttpActionsClient.register(username, email, password);

    if (userFromServer != null) {
      if (userFromServer.errorMessage != Constants.empty) {
        setState(() {
          errorMsg = userFromServer.errorMessage;
        });

        return;
      }
    }

      callback.call(userFromServer);

  }

  // Map<String, dynamic> toJson(email, password) {
  //   // var encryptedWithAES = encryptWithAES(password, email);
  //   var encryptedWithAES_2 = encryptWithAES(
  //       email, createKey(UrlConstants.URL_ENC));
  //   var encryptedWithAES = encryptWithAES(
  //       password, createKey(encryptedWithAES_2.base64));
  //   // var encryptedWithAES_2 = encryptWithAES(email, encryptedWithAES.base64);
  //
  //
  //   print('sending ' + encryptedWithAES_2.base64 + ' size ' +
  //       encryptedWithAES_2.base64.length.toString());
  //   print('sending ' + encryptedWithAES.base64 + ' size ' +
  //       encryptedWithAES.base64.length.toString());
  //
  //   return {
  //     "email": encryptedWithAES_2.base64,
  //     "password": encryptedWithAES.base64,
  //     "username": username
  //   };
  // }
}

