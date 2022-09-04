import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/OddsPage.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';

class GestureDetectorForOdds extends StatefulWidget {

  int eventId;

  UserPrediction ?prediction;

  List<UserPrediction> toRemove;

  Function(List<UserPrediction>) ?callback;

  TextAlign align;

  GestureDetectorForOdds({
    required this.prediction,
    required this.callback,
    required this.toRemove,
    required this.eventId,
    required this.align
  });

  @override
  GestureDetectorForOddsState createState() => GestureDetectorForOddsState(align: align, prediction: prediction, eventId: eventId, toRemove: toRemove, callback: callback);
}

class GestureDetectorForOddsState extends State<GestureDetectorForOdds>{

  TextAlign align;

  int eventId;

  Function(List<UserPrediction>) ?callback;

  UserPrediction ?prediction;

  List<UserPrediction> toRemove;

  GestureDetectorForOddsState({
    required this.prediction,
    required this.callback,
    required this.toRemove,
    required this.eventId,
    required this.align
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
                      onTap: () {if (OddsPage.selectedOdds.contains(prediction)) {
                        setState(() {
                          OddsPage.selectedGames.remove(eventId);
                          OddsPage.selectedOdds.remove(prediction);
                        });
                      } else {
                        setState(() {
                          OddsPage.selectedGames.add(eventId);
                          OddsPage.selectedOdds.add(prediction!);

                          for (UserPrediction unwanted in toRemove) {
                            OddsPage.selectedOdds.remove(unwanted);
                          }
                        });
                      }

                      callback?.call(OddsPage.selectedOdds);
                      },

                      child: Container(

                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),

                          color: OddsPage.selectedOdds.contains(prediction)
                              ? Colors.blueAccent
                              : Colors.grey[200],
                        ),


                          child: Padding(padding: EdgeInsets.all(4), child: Align(alignment: Alignment.center, child : Text(  (prediction!.value.toStringAsFixed(2)), style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16, color: OddsPage.selectedOdds.contains(prediction)
                              ? Colors.white
                              : Colors.blueAccent), textAlign: TextAlign.center))))
    );

  }


}


