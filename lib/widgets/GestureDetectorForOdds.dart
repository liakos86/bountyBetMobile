import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/OddsPage.dart';

import '../models/UserPrediction.dart';
import '../models/constants/ColorConstants.dart';
import '../models/match_event.dart';

class GestureDetectorForOdds extends StatefulWidget {

 List<UserPrediction> selectedOdds = <UserPrediction>[];

  int eventId;

  String predictionText;

  UserPrediction? prediction;

  List<UserPrediction?>? toRemove;

  Function( UserPrediction) callbackForOdds;

  GestureDetectorForOdds({
    Key ?key,
    // required this.selected,
    required this.selectedOdds,
    required this.prediction,
    required this.predictionText,
    required this.callbackForOdds,
    required this.toRemove,
    required this.eventId,
  }): super(key: key);

  @override
  GestureDetectorForOddsState createState() => GestureDetectorForOddsState(selectedOdds: selectedOdds, prediction: prediction, predictionText: predictionText, eventId: eventId, toRemove: toRemove, callbackForOdds: callbackForOdds);
}

class GestureDetectorForOddsState extends State<GestureDetectorForOdds>{

  int eventId;

  // UserPrediction? selected;

  List<UserPrediction> selectedOdds = <UserPrediction>[];

  Function( UserPrediction) callbackForOdds;

  UserPrediction? prediction;

  String predictionText;

  List<UserPrediction?>? toRemove;

  GestureDetectorForOddsState({
    // required this.selected,
    required this.selectedOdds,
    required this.prediction,
    required this.predictionText,
    required this.callbackForOdds,
    required this.toRemove,
    required this.eventId
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
                      onTap: () {
                        callbackForOdds.call(prediction!);
                      },

                      child:
                      Transform(
                      transform: Matrix4.skewX(-0.2),
                      child:
                      Container(
                        height: 32,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: selectedOdds.contains(prediction)
                              ? const Color(ColorConstants.my_green)
                              : Colors.grey[100],
                        ),

                          child:
                          Row(

                              children:[

                                Expanded(flex: 1, child:
                                Align(alignment: Alignment.centerLeft,  child : Text(  predictionText, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 12, color: selectedOdds.contains(prediction)
                                    ? Colors.white : Colors.grey[700]), textAlign: TextAlign.left)),
                                ),

                          Expanded(flex: 1, child:
                                Align(alignment: Alignment.centerRight,  child : Text(  (prediction?.value.toStringAsFixed(2) ?? 'EEE'), style: TextStyle(fontWeight:FontWeight.bold, fontSize: 12, color: selectedOdds.contains(prediction)
                                    ? Colors.white : Colors.grey[700]), textAlign: TextAlign.right))
                          )
                              ])
                      )
    )
    );

  }

  Widget _buildTiltedPosition(String text) {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            // margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(ColorConstants.my_green), // Background color of the parallelogram
              borderRadius: BorderRadius.circular(8),
            ),
            child:

            Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)

        ),
      );
  }



}


