import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';
import 'package:flutter_app/widgets/LogoWithName.dart';

import '../../enums/Sport.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';

class UserPredictionRowTilted extends StatefulWidget {

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;

  const UserPredictionRowTilted({
    Key? key,
    required this.prediction,
    required this.callback
  }) : super(key: key);

  @override
  UserPredictionRowTiltedState createState() => UserPredictionRowTiltedState();

}

class UserPredictionRowTiltedState extends State<UserPredictionRowTilted>{

  late UserPrediction prediction;

  late Function(UserPrediction)? callback;

  @override
  Widget build(BuildContext context) {
    prediction = widget.prediction;
    callback = widget.callback;

    return

      // Stack(
      //     clipBehavior: Clip.none, // Allow positioning outside the container
      //     children: [

      Container(
        padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: BoxDecoration(
    color: const Color(ColorConstants.my_dark_grey)
    , // Dark background color
    borderRadius: BorderRadius.circular(12),
    ),
    child:

      Wrap(

          children: [

                      Row(children: [

                      Expanded(flex: 10, child:
                        //   Padding(
                        // padding: EdgeInsets.only(left: 16),
                        //     child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LogoWithName(logoUrl: prediction.homeTeam.logo, logoSize: 20, fontSize: 12, name: prediction.homeTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),
                            LogoWithName(logoUrl: prediction.awayTeam.logo, logoSize: 20, fontSize: 12, name: prediction.awayTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),

                          ],
                        )
                      // )
                      ),

                        Expanded(flex: 4, child:
                        Align(
                          alignment: Alignment.center,
                          child:
                            DisplayOdd(betPredictionType: prediction.betPredictionType!, prediction: prediction, odd: prediction),
                        )
                        ),

                        Expanded(flex: 2, child:
                        _buildResultIcon()
                        ),



                      ],)
                  // ),

                //),

          ],
      //  )


    )
      );
      //     ,
      //
      //       Positioned(
      //           top: 10, // Slightly above the container
      //           left: -5, // Slightly left of the container
      //           child:
      //
      //            _buildResultIcon()
      //
      //
      //       ),
      //
      //
      //
      //                 ]
      // );
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

  Widget _buildResultIcon() {
    return callback == null ?

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: prediction.betPredictionStatus==BetPredictionStatus.WON ? const Color(ColorConstants.my_green) : (prediction.betPredictionStatus==BetPredictionStatus.LOST ? Colors.red : Colors.blueAccent) ,// Color(0xFF2C2C2E), // Background color for circular icon
        ),
        child: prediction.betPredictionStatus==BetPredictionStatus.WON ?
        const Icon(Icons.check, color: Colors.white, size: 18)
            : prediction.betPredictionStatus==BetPredictionStatus.LOST ?
        const Icon(Icons.highlight_remove, color: Colors.white, size: 18)
            : prediction.betPredictionStatus==BetPredictionStatus.PENDING ?
        const Icon(Icons.downloading_rounded, color: Colors.white, size: 18)
            :
        const Icon(Icons.pause, color: Colors.grey, size: 18),
      ),
    )

    :

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
    ;
  }


  //
  // //positioned
  // Expanded(flex: 1, child:
  //
  //
  // callback == null ?
  // (
  // prediction.betPredictionStatus==BetPredictionStatus.WITHDRAWN ?
  // const Icon( Icons.timer, color:   Colors.black45) :
  // prediction.betPredictionStatus==BetPredictionStatus.LOST ?
  // const Icon( Icons.highlight_remove, color:   Colors.red)
  //     : prediction.betPredictionStatus==BetPredictionStatus.WON ?
  // const Icon(Icons.check_circle_outline_outlined, color:   Colors.green) :
  // const Icon(Icons.pending_outlined, color:   Colors.black)
  // ) :
  //
  // (IconButton(
  // style: ButtonStyle(
  // elevation: MaterialStateProperty.all<double>(4),
  // foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
  // ),
  // onPressed: () {
  // callback!.call(prediction);
  // },
  // icon: const Icon(Icons.delete, color: Colors.red,),
  // ))
  //
  //
  // )

}