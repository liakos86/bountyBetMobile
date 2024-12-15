import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/constants/Constants.dart';
import '../models/constants/UrlConstants.dart';
import '../pages/ParentPage.dart';

class DialogUserRegistered extends StatelessWidget{

  String text ='';


  DialogUserRegistered({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
         text, style: TextStyle(color: Colors.black),
        ),

        TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(10),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        )

      ],

    );
  }

  void registerWith(String email, String password) async{
      if (email.length<3 || !email.contains('@gmail.com') || password.length <= 8){
        return;
      }

      try {

        if (access_token == null) {
          access_token = await SecureUtils().retrieveValue(
              Constants.accessToken);
          await authorizeAsync();
          if (access_token == null) {
            print('register COULD NOT AUTHORIZE ********************************************************************');
            return;
          }
        }

        Response registerResponse = await post(Uri.parse(UrlConstants.POST_REGISTER_USER),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              'Authorization': 'Bearer $access_token'
            },
            body: jsonEncode(toJson(email, password)),
            encoding: Encoding.getByName("utf-8")).timeout(
            const Duration(seconds: 10));

        var responseDec = jsonDecode(registerResponse.body);
        User userFromServer = User.fromJson(responseDec);

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
        "password": encryptedWithAES.base64
      };
    }

}