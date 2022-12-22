

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../models/Score.dart';
import '../models/match_event.dart';
import 'LogoWithTeamName.dart';

class LiveMatchRow extends StatefulWidget {

  final MatchEvent gameWithOdds;

  bool blink;

  LiveMatchRow({Key ?key, required this.gameWithOdds, required this.blink}) : super(key: key);

  @override
  LiveMatchRowState createState() => LiveMatchRowState(gameWithOdds: gameWithOdds, blink: blink);
}

class LiveMatchRowState extends State<LiveMatchRow> {

  MatchEvent gameWithOdds;

  bool blink;

  LiveMatchRowState({
    required this.gameWithOdds,
    required this.blink
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

          decoration: BoxDecoration(color: gameWithOdds.changeEvent == ChangeEvent.NONE ? Colors.white : Colors.green[100],
            //  borderRadius: BorderRadius.only(topLeft:  Radius.circular(2), topRight:  Radius.circular(2)),
              border: Border(
              top: BorderSide(width: 0.3, color: Colors.grey.shade600),
              left: BorderSide(width: 0, color: Colors.transparent),
                right: BorderSide(width: 0, color: Colors.transparent),
                bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
                ), ),
          child:

              Padding(
    padding: EdgeInsets.all(6),
              child:
          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                Expanded(//first column
                    flex: 10,
                    child:

                    Column(

                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                      LogoWithTeamName(key: UniqueKey(), team: gameWithOdds.homeTeam),
                        ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                      LogoWithTeamName(key: UniqueKey(), team: gameWithOdds.awayTeam),
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
                      Text(textFromStatus(gameWithOdds), style: TextStyle(
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

      )));
  }

  String textFromStatus(MatchEvent event) {

    if (event.status_for_client != null) {
      String status = event.status_for_client! + (blink ? "'" : "");
      return status;
    }

    return event.status;
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


