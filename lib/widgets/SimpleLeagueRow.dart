

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import '../models/Score.dart';
import '../models/league.dart';
import '../models/match_event.dart';
import '../pages/LeagueStandingPage.dart';
import 'LogoWithLeague.dart';

class SimpleLeagueRow extends StatefulWidget {

  final League league;


  SimpleLeagueRow({Key ?key, required this.league}) : super(key: key);

  @override
  SimpleLeagueRowState createState() => SimpleLeagueRowState(league: league);
}

class SimpleLeagueRowState extends State<SimpleLeagueRow> {

  League league;

  SimpleLeagueRowState({
    required this.league
  });


  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
        onTap: () {

          if (league.seasons==null || league.seasons.isEmpty){
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeagueStandingPage(league)),
          );

    },
    child:
      DecoratedBox(

          decoration: BoxDecoration(color: Colors.white ),
          child:

          Row(//top father

              mainAxisSize: MainAxisSize.max,
              children: [
                // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                Expanded(//first column
                    flex: 2,
                    child:

                    Column(

                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Padding(
                            padding: EdgeInsets.all(6), child:

                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Image.network(
                                      league.logo ?? "https://tipsscore.com/resb/no-league.png",
                                      height: 48,
                                      width: 48
                                  )),
                              WidgetSpan(child: SizedBox(width: 30)),

                            ],
                          ),
                        )

                        ),
                        ),

                    ]
                )),
      //), // FIRST COLUMN END

                Expanded(//first column
                    flex: 10,
                    child:

                    Column(

                        children: [
                          Row(
                          children:[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(league.name + league.league_id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                          ),
                         ] ),

                          Row(
                              children:[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  Text(league.section?.name ?? 'Section null',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black)),
                                ),
                              ] )
                        ]
                    )),

              ])//parent column end

      ));
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


