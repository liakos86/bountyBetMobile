import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
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

      await HttpActionsClient.registerWith(email, password);

    }



}