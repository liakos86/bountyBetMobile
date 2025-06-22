import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/widgets/LogoWithName.dart';

import '../../enums/Sport.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';

class UserPredictionRow extends StatefulWidget {

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;

  const UserPredictionRow({
    Key? key,
    required this.prediction,
    required this.callback
  }) : super(key: key);

  @override
  UserPredictionRowState createState() => UserPredictionRowState();

}

class UserPredictionRowState extends State<UserPredictionRow>{

  late UserPrediction prediction;

  late Function(UserPrediction)? callback;

  @override
  Widget build(BuildContext context) {
    prediction = widget.prediction;
    callback = widget.callback;

    return Wrap(

          children: [
                // Container(
                    //height: 50,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     gradient: LinearGradient(
                    //         begin: Alignment.bottomCenter,
                    //         end: Alignment.topCenter,
                    //         colors: [
                    //           prediction.betPredictionStatus==BetPredictionStatus.LOST ?
                    //
                    //           Colors.deepOrange.withOpacity(0.1) :
                    //           (prediction.betPredictionStatus==BetPredictionStatus.WON ? Colors.green.withOpacity(0.2) :
                    //
                    //           Colors.transparent),
                    //
                    //           Colors.transparent
                    //         ]
                    //     )
                    // ),

                  // child:
                  // Padding(
                  //     padding: const EdgeInsets.all(0),
                  //     child:
                      Row(children: [

                        // Expanded(flex: 1, child:
                        //
                        // Sport.ofId(prediction.sportId) == Sport.soccer ?
                        //     const Icon( Icons.sports_soccer_rounded, color:   Colors.black)
                        // :   const Icon( Icons.sports_basketball_rounded, color:   Colors.orange),
                        // ),

                      Expanded(flex: 6, child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LogoWithName(goalScored:false, isHomeTeam: true, logoUrl: prediction.homeTeam.logo, logoSize: 20, fontSize: 12, name: prediction.homeTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),
                            LogoWithName(goalScored:false, isHomeTeam: false, logoUrl: prediction.awayTeam.logo, logoSize: 20, fontSize: 12, name: prediction.awayTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),

                          ],
                        )
                      ),

                        Expanded(flex: 6, child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${predictionTypeTextOf(prediction.betPredictionType)} @ ${prediction.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                              maxLines: 3, overflow: TextOverflow.clip,)
                          ],
                        )
                        ),

                      Expanded(flex: 1, child:


                          callback == null ?
                          (
                              prediction.betPredictionStatus==BetPredictionStatus.WITHDRAWN ?
                              const Icon( Icons.timer, color:   Colors.black45) :
                        prediction.betPredictionStatus==BetPredictionStatus.LOST ?
                        const Icon( Icons.highlight_remove, color:   Colors.red)
                            : prediction.betPredictionStatus==BetPredictionStatus.WON ?
                        const Icon(Icons.check_circle_outline_outlined, color:   const Color(ColorConstants.my_green)) :
                        const Icon(Icons.pending_outlined, color:   Colors.black)
                          ) :

                          (IconButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(4),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
                            ),
                            onPressed: () {
                              callback!.call(prediction);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red,),
                          ))


                      )

                      ],)
                  // ),

                //),

          ],
      //  )


    );
  }

  String predictionTypeTextOf(BetPredictionType? betPredictionType) {
        if (BetPredictionType.AWAY_WIN == betPredictionType ){
          return prediction.awayTeam.getLocalizedName();
        }

        if (BetPredictionType.HOME_WIN == betPredictionType ){
          return prediction.homeTeam.getLocalizedName();
        }

        return 'Draw';
  }

}