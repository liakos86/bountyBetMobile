import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/examples/util/encryption.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/utils/SecureUtils.dart';
import 'package:http/http.dart';

import '../models/User.dart';
import '../models/UserPrediction.dart';
import '../models/constants/UrlConstants.dart';
import 'UserPlacedBetPredictionRow.dart';

class DialogSuccessfulBet extends StatelessWidget{

  UserBet newBet;


  DialogSuccessfulBet({required this.newBet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.all(8),
            backgroundColor: Colors.white,
            subtitle: Text('Bet: ' + newBet.betAmount.toStringAsFixed(2)),
            leading: Icon(Icons.sports, color: Colors.orangeAccent),
            title: Text('Possible earnings: ' + newBet.toReturn().toStringAsFixed(2),
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
            children: newBet.predictions.map((item)=> _buildSelectedOddRow(item)).toList()
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
          child: Text('Close'),
        )

      ],

    );
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    return UserPlacedBetPredictionRow(prediction: bettingOdd);
  }
}