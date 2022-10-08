

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/widgets/LogoWithTeam.dart';
import '../models/Score.dart';
import '../models/match_event.dart';

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

      DecoratedBox(

          decoration: BoxDecoration(color: gameWithOdds.changeEvent == ChangeEvent.NONE ? Colors.white : Colors.greenAccent),
          child:
          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                Expanded(//first column
                    flex: 6,
                    child:

                        Align(
                    alignment: Alignment.centerLeft,
                    child:

                    Column(

                    children: [

                      LogoWithTeam(key: UniqueKey(), team: gameWithOdds.homeTeam),

                      LogoWithTeam(key: UniqueKey(), team: gameWithOdds.awayTeam),

                    ]

                ))), // FIRST COLUMN END

                Expanded(
                    flex: 2,
                    child:

                Column(//second column
                    children: [
                     Padding(padding: EdgeInsets.all(6), child:
                      Text(textFrom(gameWithOdds.status_for_client), style: TextStyle(
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),)),

                      Padding(padding: EdgeInsets.all(8), child:
                      Text(textScoreFrom(gameWithOdds.awayTeamScore), style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),))
                    ]
                ))//THIRD COLUMN END


              ])//parent column end

      );
  }

  String textFrom(String? status_more) {
    if (status_more != null) {
      return status_more;
    }

    return MatchConstants.FT;
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

