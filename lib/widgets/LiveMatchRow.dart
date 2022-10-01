
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
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
        Column(

       // key: ValueKey(gameWithOdds.eventId.toInt()),
          children: [

            Row(mainAxisSize: MainAxisSize.max,

              children: [
                Expanded(
                    flex: 4, child: Padding(padding: EdgeInsets.all(8), child:

                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(child: Image.network(
                        gameWithOdds.homeTeam.logo,
                        height: 24,
                        width: 24,
                      )),
                      TextSpan(text: gameWithOdds.homeTeam.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14, color: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? Colors.white : Colors.black)),
                      WidgetSpan(child: SizedBox(width: 10)),
                      TextSpan(
                          text: textScoreFrom(gameWithOdds.homeTeamScore),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),


                    ],
                  ),
                )

                )),
                Expanded(flex: 1,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: Text("-", style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.center))),


                Expanded(
                    flex: 4, child: Padding(padding: EdgeInsets.all(8), child:

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: textScoreFrom(gameWithOdds.awayTeamScore),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      WidgetSpan(child: SizedBox(width: 10)),
                      TextSpan(text: gameWithOdds.awayTeam.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14, color: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.white : Colors.black)),
                      WidgetSpan(child: Image.network(
                        gameWithOdds.awayTeam.logo,
                        height: 24,
                        width: 24,
                      )),

                    ],
                  ),
                )

                )),

                Expanded(
                    flex: 1, child: Padding(padding: EdgeInsets.all(8), child:

                Text(textFrom(gameWithOdds.status_for_client), style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),)))

              ],),


            Divider(color: Colors.blueAccent, height: 4, thickness: 0.5,),


          ]

      )

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


