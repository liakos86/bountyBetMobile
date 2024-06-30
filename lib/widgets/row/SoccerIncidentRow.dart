

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../../models/Score.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';
import '../SoccerIncidentBox.dart';

class SoccerIncidentRow extends StatefulWidget {

  final MatchEventIncidentSoccer incident;


  SoccerIncidentRow({Key ?key, required this.incident}) : super(key: key);

  @override
  SoccerIncidentRowState createState() => SoccerIncidentRowState(statistic: incident);
}

class SoccerIncidentRowState extends State<SoccerIncidentRow> {

  MatchEventIncidentSoccer statistic;

  SoccerIncidentRowState({
    required this.statistic
  });


  @override
  Widget build(BuildContext context) {

    bool isHomeStat = homeTeamStat(statistic);

    return

              Padding(
    padding: const EdgeInsets.all(4),
              child:
          Row(//top father

              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                  isHomeStat ? SoccerIncidentBox(incident : statistic) : const Spacer(),

                  isHomeStat  ? const Spacer() : SoccerIncidentBox(incident : statistic),

                ]
                ),
              // ]
              // )//parent column end
    //  )
    );
  }


  homeTeamStat(MatchEventIncidentSoccer statistic) {
   return  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
  }
}


