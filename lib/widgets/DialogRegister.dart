import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/UrlConstants.dart';

class DialogRegister extends StatelessWidget{

  String email ='';

  String password = '';

  String username = '';

  Function callback = (User user)=>{};

  DialogRegister({required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextField(
          controller: null,
          onChanged: (text){
            this.email = text;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your email',
          ),
        ),

        TextField(
          controller: null,
          onChanged: (text){
            this.username = text;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your username',
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
            registerWith(email, password, username);
          },
          child: Text('Register'),
        )

      ],

    );
  }

  void registerWith(String email, String password, String username) async{
      if (username.length< 5 || email.length<5 || !email.contains('@gmail.com') || password.length <= 8){
        return;
      }

      try {
        Response registerResponse = await post(Uri.parse(UrlConstants.POST_REGISTER_USER),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: jsonEncode(toJson(email, password)),
            encoding: Encoding.getByName("utf-8")).timeout(
            const Duration(seconds: 10));

        var responseDec = jsonDecode(registerResponse.body);
        User userFromServer = User.fromJson(responseDec);

        callback.call(userFromServer);

      }catch(e){
        print(e);
      }
    }

    Map<String, dynamic> toJson(email, password) {

    // var encryptedWithAES = encryptWithAES(password, email);
      var encryptedWithAES_2 = encryptWithAES(email, createKey(UrlConstants.URL_ENC));
    var encryptedWithAES = encryptWithAES(password, createKey(encryptedWithAES_2.base64));
    // var encryptedWithAES_2 = encryptWithAES(email, encryptedWithAES.base64);


    print('sending ' +encryptedWithAES_2.base64 + ' size ' + encryptedWithAES_2.base64.length.toString() );
    print('sending ' +encryptedWithAES.base64+ ' size ' + encryptedWithAES.base64.length.toString() );

      return {
        "email": encryptedWithAES_2.base64,
        "password": encryptedWithAES.base64,
        "username": username
      };
    }

}