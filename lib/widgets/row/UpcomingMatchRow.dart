import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';

import '../../enums/WinnerType.dart';
import '../../models/UserPrediction.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';

  class UpcomingOrEndedMatchRow extends StatefulWidget {

    final List<UserPrediction> selectedOdds;

    final MatchEvent gameWithOdds;

    final Function(UserPrediction) callbackForOdds;

    const UpcomingOrEndedMatchRow({Key ?key, required this.gameWithOdds, required this.callbackForOdds, required this.selectedOdds}) : super(key: key);

    @override
    UpcomingOrEndedMatchRowState createState() => UpcomingOrEndedMatchRowState(gameWithOdds: gameWithOdds, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

  class UpcomingOrEndedMatchRowState extends State<UpcomingOrEndedMatchRow> {

    UserPrediction? selectedPrediction;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function(UserPrediction) callbackForOdds;

    MatchEvent gameWithOdds;

    UpcomingOrEndedMatchRowState({
      required this.selectedOdds,
      required this.gameWithOdds,
      required this.callbackForOdds
    });

    @override
    Widget build(BuildContext context) {
      return

        Wrap( //top parent
            spacing: 0,

            children: [

             if (1 > 2)

                DecoratedBox( //first child
                    decoration: BoxDecoration(color: Colors.white,
                      border: Border(
                        top: BorderSide(
                            width: 0.3, color: Colors.grey.shade600),
                        left: const BorderSide(
                            width: 0, color: Colors.transparent),
                        right: const BorderSide(
                            width: 0, color: Colors.transparent),
                        bottom: BorderSide(
                            width: 0.3, color: Colors.grey.shade600),
                      ),
                    ),
                    child:
                    Row( //top father
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          //      Expanded(flex:1, child: Container()),

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
                                            logoUrl: gameWithOdds.homeTeam.logo,
                                            name: gameWithOdds.homeTeam
                                                .getLocalizedName(),
                                            redCards: 0,
                                            logoSize: 24,
                                            fontSize: 14,
                                            winnerType: WinnerType.NONE)),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        LogoWithName(key: UniqueKey(),
                                            logoUrl: gameWithOdds.awayTeam.logo,
                                            name: gameWithOdds.awayTeam
                                                .getLocalizedName(),
                                            redCards: 0,
                                            logoSize: 24,
                                            fontSize: 14,
                                            winnerType: WinnerType.NONE)),
                                  ]
                              )),
                          // FIRST COLUMN END

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
                              )),
                          //SECOND COLUMN END
                          //RD COLUMN END
                        ])), //parent column end



                LiveMatchRow(gameWithOdds: gameWithOdds),

              //ODDS ROW

              if (gameWithOdds.odds != null)

                Container(color: Colors.white, child:
                Row(mainAxisSize: MainAxisSize.max,

                  children: [
                    Expanded(flex: 5,
                        child: Padding(padding: const EdgeInsets.all(4),
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
                        child: Padding(padding: const EdgeInsets.all(4),
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
                        child: Padding(padding: const EdgeInsets.all(4),
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