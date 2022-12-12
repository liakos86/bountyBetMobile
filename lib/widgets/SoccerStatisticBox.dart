import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/MatchConstants.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';

import '../models/Team.dart';
import '../models/league.dart';
import '../pages/LeagueGamesPage.dart';
import 'StatPictureInPicture.dart';
import 'UpcomingMatchRow.dart';

class SoccerStatisticBox extends StatelessWidget{

  MatchEventsStatisticsSoccer statistic;

  SoccerStatisticBox({Key ?key, required this.statistic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHomeTeam = homeTeamStat(statistic);
    return

      Align(
          alignment: isHomeTeam  ? Alignment.centerLeft : Alignment.centerRight,
        child:
      Row(

        children: [
          !isHomeTeam ?  Text(textFor(statistic), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),) : SizedBox(width: 0,),
          SizedBox(width: 4,),
          StatPictureInPicture(statistic : statistic),
          SizedBox(width: 4,),
          isHomeTeam ? Text(textFor(statistic), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),) : SizedBox(width: 0,)

        ],

      ));
  }

  imageFromStatistic() {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){
      return Image.network(
        statistic.player?.photo ?? "https://tipsscore.com/resb/no-photo.png",
        width: 36,
        height: 36
      );
    }

    IconData icon = Icons.not_interested;
    if ("card" == incident_type){
      icon = Icons.add_card;
    }

    if ("goal" == incident_type){
      icon = Icons.sports_soccer;
    }

    if ("period" == incident_type){
      icon = Icons.star;
    }

    if ("injuryTime" == incident_type){
      icon = Icons.call_end;
    }

    return Icon(
      icon,
      size: 24,
    );

    return Icons.question_mark;

  }

  String textFor(MatchEventsStatisticsSoccer statistic) {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){
      return '${statistic.time}\' ${statistic.player?.name_short}\n(${statistic.player_two_in?.name_short})';
    }

    return '${statistic.time}\' ${statistic.player?.name_short}';
  }

  homeTeamStat(MatchEventsStatisticsSoccer statistic) {
    bool home =  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
    return home;
  }

}