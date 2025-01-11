import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/OddsPage.dart';

import '../enums/BetPredictionType.dart';
import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/match_event.dart';

class DisplayOdd extends StatelessWidget {

  final BetPredictionType betPredictionType;

  final UserPrediction prediction;

  final UserPrediction? odd;

  DisplayOdd({
    Key ?key,
    required this.prediction,
    required this.betPredictionType,
    required this.odd
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Padding(padding: const EdgeInsets.all(4),
        child:        Container(
            height: 24,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: betPredictionType == (prediction.betPredictionType)
                  ?  const Color(ColorConstants.my_green)  // Colors.blueAccent
                  : Colors.grey[100],
            ),

            child:
            Row(
                children:[
                  Expanded(flex: 1, child:
                  Align(alignment: Alignment.centerLeft,  child : Text(betPredictionType.text  , style: TextStyle(fontWeight:FontWeight.bold, fontSize: 8, color: betPredictionType == (prediction.betPredictionType)
                      ? Colors.white : Colors.grey[700]), textAlign: TextAlign.left)),
                  ),

                  Expanded(flex: 1, child:
                  Align(alignment: Alignment.centerRight,  child : Text(  (odd?.value.toStringAsFixed(2) ?? 'EEE'), style: TextStyle(fontWeight:FontWeight.bold, fontSize: 8, color: betPredictionType == (prediction.betPredictionType)
                      ? Colors.white : Colors.grey[700]), textAlign: TextAlign.right))
                  )
                ]
            )
        ));

  }

}


