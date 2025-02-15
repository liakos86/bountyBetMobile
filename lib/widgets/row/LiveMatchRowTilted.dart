import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/enums/LastedPeriod.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../../enums/WinnerType.dart';
import '../../models/Score.dart';
import '../../models/constants/Constants.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';

class LiveMatchRowTilted extends StatefulWidget {

  final MatchEvent gameWithOdds;


  LiveMatchRowTilted({Key ?key, required this.gameWithOdds}) : super(key: key);

  @override
  LiveMatchRowTiltedState createState() => LiveMatchRowTiltedState();
}

class LiveMatchRowTiltedState extends State<LiveMatchRowTilted> {

  late MatchEvent gameWithOdds;

  @override
  void initState() {
    super.initState();
    gameWithOdds = widget.gameWithOdds;
}


  @override
  Widget build(BuildContext context) {
    
    int homeRed = 0;
    int awayRed = 0;



    // Iterable<MatchEventIncidentSoccer> redCards = gameWithOdds.st.where((element) =>
    //   element.incident_type=="card" && (element.card_type=='Red' || element.card_type=='YellowRed'));
    //
    // for (MatchEventIncidentSoccer redCard in redCards){
    //   if (redCard.player_team==1){
    //     ++homeRed;
    //   }else if (redCard.player_team==2){
    //     ++awayRed;
    //   }
    // }

    return


          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [



                Expanded(//second column
                    flex: 14,
                    child:

                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child:

                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                onTap: () {

                  if (gameWithOdds.status != MatchEventStatus.INPROGRESS.statusStr){
                    return;
                  }

                Navigator.push(
                context,
                MaterialPageRoute(

                    builder:  (context) =>

                        MatchInfoSoccerDetailsPage(key: UniqueKey(),
                            event: gameWithOdds,
                            eventCallback: getEvent)


                )
                );
                },
                child:

                    Column(
                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.homeTeam.getLocalizedName(), logoUrl: gameWithOdds.homeTeam.logo, redCards: homeRed, logoSize: 20, fontSize: 12,  winnerType: calculateWinnerType(gameWithOdds, 1), goalScored: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ),
                        ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.awayTeam.getLocalizedName(), logoUrl: gameWithOdds.awayTeam.logo, redCards: awayRed, logoSize: 20, fontSize: 12,  winnerType: calculateWinnerType(gameWithOdds, 2), goalScored: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL),
                            )
                      ]
                    )
                )
                        )
                        // )
                ),

                Expanded(
                    flex: 3,
                    child:

                Column(//second column
                    children: [
                     Padding(padding: const EdgeInsets.all(6), child:
                      Text(
                       (gameWithOdds.display_status),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),))
                    ]
                )),//SECOND COLUMN END

                Expanded(
                    flex: 3,

                    child:

                   // (MatchEventStatus.fromStatusText(gameWithOdds.status) == MatchEventStatus.INPROGRESS) ?

                Column(// third column
                    children: [
                      Padding(padding: const EdgeInsets.all(6), child:

                      Text(gameWithOdds.textScore(true), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? 13 : 12,
                          fontWeight:  FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? Colors.redAccent : Colors.white),)),

                      Padding(padding: const EdgeInsets.all(8), child:
                      Text(gameWithOdds.textScore(false), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? 13 : 12,
                          fontWeight: FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.redAccent : Colors.white),)),
                    ]
                )

               // : Container()

                ), //THIRD COLUMN END

              ]
          // )//parent column end

      );
  }



  WinnerType calculateWinnerType(MatchEvent gameWithOdds, int homeOrAway) {

    if (MatchEventStatus.FINISHED != MatchEventStatus.fromStatusText(gameWithOdds.status)) {
      return WinnerType.NONE;
    }

    if (gameWithOdds.aggregated_winner_code != null){
      if (homeOrAway == gameWithOdds.aggregated_winner_code){
        return WinnerType.AFTER;
      }

      return WinnerType.NONE;
    }

    if (gameWithOdds.winner_code != null){

      if (homeOrAway == gameWithOdds.winner_code){
        return WinnerType.NORMAL;
      }

      return WinnerType.NONE;
    }

    return WinnerType.NONE;

  }

  getEvent(){
    return gameWithOdds;
  }





}


