

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/StandingRow.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import '../models/Score.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';

class LeagueStandingRow extends StatefulWidget {

  final StandingRow standing;


  LeagueStandingRow({Key ?key, required this.standing}) : super(key: key);

  @override
  LeagueStandingRowState createState() => LeagueStandingRowState(standing: standing);
}

class LeagueStandingRowState extends State<LeagueStandingRow> {

  StandingRow standing;

  LeagueStandingRowState({
    required this.standing
  });


  @override
  Widget build(BuildContext context) {
    return

      SizedBox(

          height: 48,

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
                      LogoWithName(key: UniqueKey(), name: standing.team.name, logoUrl: standing.team.logo,),
                        )
                    ]
                )),
      //), // FIRST COLUMN END
                Expanded(
                    flex: 2,
                    child:
                Column(//second column
                    children: [
                     Padding(padding: EdgeInsets.all(6), child:
                      Text((standing.home_points + standing.away_points).toString(), style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),))
                    ]
                )),//SECOND COLUMN END
              ])//parent column end
      );
  }
}


