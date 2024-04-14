import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';

  class UpcomingMatchRow extends StatefulWidget {

    final List<UserPrediction> selectedOdds;

    final MatchEvent gameWithOdds;

    final Function(UserPrediction) callbackForOdds;

    const UpcomingMatchRow({Key ?key, required this.gameWithOdds, required this.callbackForOdds, required this.selectedOdds}) : super(key: key);

    @override
    UpcomingMatchRowState createState() => UpcomingMatchRowState(gameWithOdds: gameWithOdds, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

  class UpcomingMatchRowState extends State<UpcomingMatchRow> {

    UserPrediction? selectedPrediction;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function(UserPrediction) callbackForOdds;

    MatchEvent gameWithOdds;

    UpcomingMatchRowState({
      required this.selectedOdds,
      required this.gameWithOdds,
      required this.callbackForOdds
    });

    @override
    Widget build(BuildContext context) {

      return

      Wrap(//top parent
          spacing: 0,

        children: [

        DecoratedBox(//first child
            decoration: BoxDecoration(color: Colors.white ,
              //  borderRadius: BorderRadius.only(topLeft:  Radius.circular(2), topRight:  Radius.circular(2)),
              border: Border(
                top: BorderSide(width: 0.3, color: Colors.grey.shade600),
                left: BorderSide(width: 0, color: Colors.transparent),
                right: BorderSide(width: 0, color: Colors.transparent),
                bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
              ), ),
            child:
            Row( //top father
                mainAxisSize: MainAxisSize.max,
                children: [
                  // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                  Expanded( //first column
                      flex: 10,
                      child:
                          Column(
                              children: [
                              Align(
                              alignment: Alignment.centerLeft,
                              child:
                                LogoWithName(key: UniqueKey(),
                                    logoUrl: gameWithOdds.homeTeam.logo, name: gameWithOdds.homeTeam.getLocalizedName(), redCards: 0, logoSize: 24, fontSize: 14,)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:
                                LogoWithName(key: UniqueKey(),
                                    logoUrl: gameWithOdds.awayTeam.logo, name: gameWithOdds.awayTeam.getLocalizedName(), redCards: 0, logoSize: 24, fontSize: 14,)),
                              ]
                          )), // FIRST COLUMN END

                  Expanded(
                      flex: 6,

                      child:
                      Column( //second column
                          children: [
                            Align(alignment: Alignment.center, child:
                            Text(
                              (gameWithOdds.start_at_local),

                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),))
                          ]
                      )), //SECOND COLUMN END
                  //RD COLUMN END
                ])), //parent column end

          //ODDS ROW

     if (gameWithOdds.odds != null)

       Container(color: Colors.white, child:
          Row(mainAxisSize: MainAxisSize.max,


            children: [
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selectedOdds: selectedOdds,
                        eventId: gameWithOdds.eventId,
                        predictionText: '1:',
                        callbackForOdds: callbackForOdds,
                        prediction: gameWithOdds.odds?.odd1,
                        toRemove: [
                          gameWithOdds.odds?.odd2,
                          gameWithOdds.odds?.oddX
                        ],))),
              Expanded(flex: 4,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selectedOdds: selectedOdds,
                        eventId: gameWithOdds.eventId,
                        predictionText: 'X:',
                        callbackForOdds: callbackForOdds,
                        prediction: gameWithOdds.odds?.oddX,
                        toRemove: [
                          gameWithOdds.odds?.odd2,
                          gameWithOdds.odds?.odd1
                        ],))),
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selectedOdds: selectedOdds,
                        eventId: gameWithOdds.eventId,
                        predictionText: '2:',
                        callbackForOdds: callbackForOdds,
                        prediction: gameWithOdds.odds?.odd2,
                        toRemove: [
                          gameWithOdds.odds?.odd1,
                          gameWithOdds.odds?.oddX
                        ],)))
            ],
          )),

       ]
     );

    }

  }
