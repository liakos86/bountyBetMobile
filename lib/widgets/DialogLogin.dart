import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/UrlConstants.dart';

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
    return Column(
      children: [

        Text(errorMsg, style: TextStyle(color: Colors.red)),

        TextField(
          controller: null,
          onChanged: (text){
            this.emailOrUsername = text;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email or username',
          ),
        ),

        TextField(

          controller: null,
          onChanged: (text){
            this.password = text;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your password',
          ),
        ),

        TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(10),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
          ),
          onPressed: () {
            loginWith(emailOrUsername, password);
          },
          child: Text('Login'),
        )

      ],

    );
  }

  void loginWith(String emailOrUsername, String password) async{
      if (emailOrUsername.length < 5 ){

        setState(() {
          errorMsg = 'Username must be at least 5 characters long';
        });

        return;
      }

      if (password.length < 1 ){

        setState(() {
          errorMsg = 'Invalid username or password';
        });

        return;
      }

      try {
        Response loginResponse = await post(Uri.parse(UrlConstants.POST_LOGIN_USER),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: jsonEncode(toJson(emailOrUsername, password)),
            encoding: Encoding.getByName("utf-8")).timeout(
            const Duration(seconds: 5));

        var responseDec = jsonDecode(loginResponse.body);
        User userFromServer = User.fromJson(responseDec);

        callback.call(userFromServer);

      }catch(e){

        setState(() {
          errorMsg = 'Login failed server error';
        });

        print(e);
      }
    }

    Map<String, dynamic> toJson(emailOrUsername, password) {

      var encryptedWithAES_2 = encryptWithAES(emailOrUsername, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(password, createKey(encryptedWithAES_2.base64));

    print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

      return {
        "email": encryptedWithAES_2.base64,
        "password": encryptedWithAES.base64,
        "username": emailOrUsername
      };
    }



}