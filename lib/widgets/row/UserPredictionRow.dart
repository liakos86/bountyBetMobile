import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';

import '../../enums/Sport.dart';
import '../../models/UserPrediction.dart';

class UserPredictionRow extends StatelessWidget{

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;

  const UserPredictionRow({
    Key? key,
    required this.prediction,
    required this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(

          children: [
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              prediction.betPredictionStatus==BetPredictionStatus.LOST ?

                              Colors.red.withOpacity(0.1) :
                              (prediction.betPredictionStatus==BetPredictionStatus.WON ? Colors.green.withOpacity(0.2) :

                              Colors.transparent),

                              Colors.transparent
                            ]
                        )
                    ),

                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(children: [

                        Expanded(flex: 1, child:

                        Sport.ofId(prediction.sportId) == Sport.soccer ?
                            const Icon( Icons.sports_soccer_rounded, color:   Colors.black)
                        :   const Icon( Icons.sports_basketball_rounded, color:   Colors.orange),
                        ),

                      Expanded(flex: 8, child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${prediction.homeTeam.name} - ${prediction.awayTeam.name}',
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              maxLines: 1, overflow: TextOverflow.clip,),
                            const SizedBox(height: 4),
                            Text('${predictionTypeTextOf(prediction.betPredictionType)} @ ${prediction.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                              maxLines: 1, overflow: TextOverflow.clip,)
                          ],
                        )
                      ),

                      Expanded(flex: 1, child:

                          callback == null ?
                          (
                        prediction.betPredictionStatus==BetPredictionStatus.LOST ?
                        const Icon( Icons.highlight_remove, color:   Colors.red)
                            : prediction.betPredictionStatus==BetPredictionStatus.WON ?
                        const Icon(Icons.check_circle_outline_outlined, color:   Colors.green) :
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
                  ),

                ),
            // Positioned(bottom : 0,
            //   child: Padding(
            //       padding: const EdgeInsets.all(8),
            //       child: Row(children: [
            //
            //       prediction.betPredictionStatus==BetPredictionStatus.LOST ?
            //
            //         const Icon( Icons.highlight_remove, color:   Colors.red)
            //           : prediction.betPredictionStatus==BetPredictionStatus.WON ?
            //         const Icon(Icons.check_circle_outline_outlined, color:   Colors.green) :
            //         const Icon(Icons.pending_outlined, color:   Colors.black),
            //         const SizedBox(width: 4),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Text('${prediction.homeTeam.name} - ${prediction.awayTeam.name}',
            //               style: const TextStyle(fontSize: 12, color: Colors.black),
            //             maxLines: 1, overflow: TextOverflow.clip,),
            //             const SizedBox(height: 4),
            //             Text('${prediction.betPredictionType} @ ${prediction.value.toStringAsFixed(2)}',
            //               style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
            //               maxLines: 1, overflow: TextOverflow.clip,)
            //           ],
            //         ),
            //
            //       ],)
            //   ),
            // ),
          ],
      //  )


    );
  }

  String predictionTypeTextOf(BetPredictionType? betPredictionType) {
        if (BetPredictionType.AWAY_WIN == betPredictionType ){
          return prediction.awayTeam.name;
        }

        if (BetPredictionType.HOME_WIN == betPredictionType ){
          return prediction.homeTeam.name;
        }

        return 'Draw';
  }

}