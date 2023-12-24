

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../models/Score.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';
import 'SoccerIncidentBox.dart';

class SoccerIncidentRow extends StatefulWidget {

  final MatchEventIncidentsSoccer incident;


  SoccerIncidentRow({Key ?key, required this.incident}) : super(key: key);

  @override
  SoccerIncidentRowState createState() => SoccerIncidentRowState(statistic: incident);
}

class SoccerIncidentRowState extends State<SoccerIncidentRow> {

  MatchEventIncidentsSoccer statistic;

  SoccerIncidentRowState({
    required this.statistic
  });


  @override
  Widget build(BuildContext context) {

    bool isHomeStat = homeTeamStat(statistic);

    return
      // DecoratedBox(
      //
      //     decoration: const BoxDecoration(color:  Colors.transparent,
      //       //  borderRadius: BorderRadius.only(topLeft:  Radius.circular(2), topRight:  Radius.circular(2)),
      //         ),
      //     child:

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


  homeTeamStat(MatchEventIncidentsSoccer statistic) {
   return  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
  }
}


