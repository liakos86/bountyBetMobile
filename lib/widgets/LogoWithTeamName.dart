import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';

import '../models/Team.dart';
import '../models/league.dart';
import '../pages/LeagueGamesPage.dart';
import 'UpcomingMatchRow.dart';

class LogoWithTeamName extends StatelessWidget{

  Team team;

  LogoWithTeamName({Key ?key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Row(

      children: [
        Expanded(
            flex: 2,
            child: Container(

                child: Image.network(
                  team.logo,
                  height: 24,
                  width: 24,
                ),
        )),

        Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(left: 0, top:8, bottom: 8),

              child: Column(
              children:  [Align(
                  alignment: Alignment.centerLeft,
                  child: Container( child: Text(team.name, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),))),
                 ]))),

      ],

    );
  }

}