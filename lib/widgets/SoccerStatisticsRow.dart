

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../models/Score.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';
import 'SoccerStatisticBox.dart';

class SoccerStatisticsRow extends StatefulWidget {

  final MatchEventsStatisticsSoccer statistic;


  SoccerStatisticsRow({Key ?key, required this.statistic}) : super(key: key);

  @override
  SoccerStatisticsRowState createState() => SoccerStatisticsRowState(statistic: statistic);
}

class SoccerStatisticsRowState extends State<SoccerStatisticsRow> {

  MatchEventsStatisticsSoccer statistic;

  SoccerStatisticsRowState({
    required this.statistic
  });


  @override
  Widget build(BuildContext context) {
    return
      DecoratedBox(

          decoration: BoxDecoration(color:  Colors.transparent,
            //  borderRadius: BorderRadius.only(topLeft:  Radius.circular(2), topRight:  Radius.circular(2)),
              ),
          child:

              Padding(
    padding: EdgeInsets.all(4),
              child:
          Row(//top father

              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                 homeTeamStat(statistic)  ? SoccerStatisticBox(statistic : statistic) : Text(''),

                  homeTeamStat(statistic)  ? Text('') : SoccerStatisticBox(statistic : statistic),

                ]
                ),
              // ]
              // )//parent column end
      ));
  }


  homeTeamStat(MatchEventsStatisticsSoccer statistic) {
   bool home =  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
    return home;
  }
}


