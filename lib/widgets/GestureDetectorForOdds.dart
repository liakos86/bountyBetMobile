import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/OddsPage.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';

class GestureDetectorForOdds extends StatefulWidget {

//  List<UserPrediction> selectedOdds = <UserPrediction>[];

  UserPrediction? selected;

  int eventId;

  String predictionText;

  UserPrediction prediction;

  List<UserPrediction> toRemove;

  Function( UserPrediction?) ?callbackForOdds;

  GestureDetectorForOdds({
    Key ?key,
    required this.selected,
    //required this.selectedOdds,
    required this.prediction,
    required this.predictionText,
    required this.callbackForOdds,
    required this.toRemove,
    required this.eventId,
  }): super(key: key);

  @override
  GestureDetectorForOddsState createState() => GestureDetectorForOddsState(selected: selected, prediction: prediction, predictionText: predictionText, eventId: eventId, toRemove: toRemove, callbackForOdds: callbackForOdds);
}

class GestureDetectorForOddsState extends State<GestureDetectorForOdds>{

  int eventId;

  UserPrediction? selected;

  //List<UserPrediction> selectedOdds = <UserPrediction>[];

  Function( UserPrediction?) ?callbackForOdds;

  UserPrediction prediction;

  String predictionText;

  List<UserPrediction> toRemove;

  GestureDetectorForOddsState({
    required this.selected,
    //required this.selectedOdds,
    required this.prediction,
    required this.predictionText,
    required this.callbackForOdds,
    required this.toRemove,
    required this.eventId
  });


  @override
  Widget build(BuildContext context) {


    if (eventId==1381702 && selected!=null) {
      print('ARSENAL BUILDING GESTURE ROW ' + selected!.betPredictionType!.text);
    }
    
    return GestureDetector(
                      onTap: () {

                          if (prediction==selected) {
                            callbackForOdds?.call(null);
                          }else{
                            callbackForOdds?.call(prediction);
                          }


                      },

                      child:

                      Container(
                        height: 36,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: selected == prediction
                              ? Colors.blueAccent
                              : Colors.grey[100],
                        ),

                          child:
                          Row(

                              children:[

                                Expanded(flex: 1, child:
                                Align(alignment: Alignment.centerLeft,  child : Text(  predictionText, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 12, color: selected == prediction
                                    ? Colors.white : Colors.grey[700]), textAlign: TextAlign.left)),
                                ),

                          Expanded(flex: 1, child:
                                Align(alignment: Alignment.centerRight,  child : Text(  (prediction.value.toStringAsFixed(2)), style: TextStyle(fontWeight:FontWeight.bold, fontSize: 12, color: selected == prediction
                                    ? Colors.white : Colors.grey[700]), textAlign: TextAlign.right))
                          )
                              ])
                      )
    );

  }


}


