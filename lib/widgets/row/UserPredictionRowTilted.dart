import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';
import 'package:flutter_app/widgets/LogoWithName.dart';

import '../../enums/MatchEventStatus.dart';
import '../../enums/Sport.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';

class UserPredictionRowTilted extends StatefulWidget {

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;

  const UserPredictionRowTilted({
    Key? key,
    required this.prediction,
    required this.callback,
  }) : super(key: key);

  @override
  UserPredictionRowTiltedState createState() => UserPredictionRowTiltedState();

}

class UserPredictionRowTiltedState extends State<UserPredictionRowTilted>{

  late UserPrediction prediction;

  late Function(UserPrediction)? callback;

  late MatchEvent? event;

  @override
  void initState() {
    prediction = widget.prediction;
    callback = widget.callback;
    event = AppContext.findEvent(prediction.eventId);
    super.initState();
    }

  @override
  Widget build(BuildContext context) {

    return

      Container(
        padding: const EdgeInsets.all(2),
    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: BoxDecoration(
    color: const Color(ColorConstants.my_dark_grey)
    , // Dark background color
    borderRadius: BorderRadius.circular(12),
    ),
    child:

                      Row(children: [

                        Expanded(flex: 10, child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LogoWithName(goalScored:false, logoUrl: prediction.homeTeam.logo, logoSize: 20, fontSize: 12, name: prediction.homeTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),
                            LogoWithName(goalScored:false, logoUrl: prediction.awayTeam.logo, logoSize: 20, fontSize: 12, name: prediction.awayTeam.getLocalizedName(), redCards: 0, winnerType: WinnerType.NONE),

                          ],
                        )
                      // )
                      ),


                      event != null ?

                         Expanded(flex: 3, child:
                         Text(event!.display_status, style: const TextStyle(
                             fontSize: 10, color: Colors.white))
                         )

                      : const Expanded(flex: 3, child:

                      SizedBox(width:0)
                      ),
                       //},

                        Expanded(flex: 4, child:
                        Align(
                          alignment: Alignment.center,
                          child:
                          DisplayOdd(betPredictionType: prediction.betPredictionType!, prediction: prediction.betPredictionType!, odd: prediction),
                        )
                        ),

                        Expanded(flex: 2, child:
                        _buildResultIcon()
                        ),


                      ],
                      )

      );

  }

  String predictionTypeTextOf(BetPredictionType? betPredictionType) {
        if (BetPredictionType.AWAY_WIN == betPredictionType ){
          return prediction.awayTeam.getLocalizedName();
        }

        if (BetPredictionType.HOME_WIN == betPredictionType ){
          return prediction.homeTeam.getLocalizedName();
        }

        return 'X';
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
        const Icon(Icons.close, color: Colors.white, size: 18)
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

}