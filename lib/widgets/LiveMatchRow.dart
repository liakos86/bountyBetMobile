

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../models/Score.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';

class LiveMatchRow extends StatefulWidget {

  final MatchEvent gameWithOdds;

  LiveMatchRow({Key ?key, required this.gameWithOdds}) : super(key: key);

  @override
  LiveMatchRowState createState() => LiveMatchRowState(gameWithOdds: gameWithOdds);
}

class LiveMatchRowState extends State<LiveMatchRow> {

  MatchEvent gameWithOdds;

  LiveMatchRowState({
    required this.gameWithOdds
  });


  @override
  Widget build(BuildContext context) {
    return

    GestureDetector(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchInfoSoccerDetailsPage(event: gameWithOdds,)),
          );
        },
    child:

      DecoratedBox(

          decoration: BoxDecoration(color: gameWithOdds.changeEvent == ChangeEvent.NONE ? Colors.white : ( ChangeEvent.isGoal(gameWithOdds.changeEvent) ? Colors.green[100] : Colors.blue[200]),
              border: Border(
              top: BorderSide(width: 0.3, color: Colors.grey.shade600),
              left: BorderSide(width: 0, color: Colors.transparent),
                right: BorderSide(width: 0, color: Colors.transparent),
                bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
                ), ),

          child:

          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(//first column
                    flex: 10,
                    child:
                    Column(
                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.homeTeam.name, logoUrl: gameWithOdds.homeTeam.logo,),
                        ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.awayTeam.name, logoUrl: gameWithOdds.awayTeam.logo),
                            )
                    ]
                )),
      //), // FIRST COLUMN END

                Expanded(
                    flex: 4,
                    child:

                Column(//second column
                    children: [
                     Padding(padding: EdgeInsets.all(6), child:
                      Text(
                       (gameWithOdds.display_status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),))
                    ]
                )),//SECOND COLUMN END

                Expanded(
                    flex: 2,

                    child:

                Column(// third column
                    children: [
                      Padding(padding: EdgeInsets.all(6), child:
                      Text(textScoreFrom(gameWithOdds.homeTeamScore), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? 13 : 12,
                          fontWeight:  FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? Colors.redAccent : Colors.black87),)),

                      Padding(padding: EdgeInsets.all(8), child:
                      Text(textScoreFrom(gameWithOdds.awayTeamScore), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? 13 : 12,
                          fontWeight: FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.redAccent : Colors.black87),)),
                    ]
                )), //THIRD COLUMN END

              ])//parent column end

      ));
  }

  String textScoreFrom(Score ?score) {
    if (score == null){
      return '-';
    }

    if (score.current == null){
      return '-';
    }

    return score.current.toString();

  }
}


