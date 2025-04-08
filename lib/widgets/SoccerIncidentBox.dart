
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';

import '../models/constants/Constants.dart';
import 'StatIncidentPictureWithText.dart';

class SoccerIncidentBox extends StatelessWidget{

  final MatchEventIncidentSoccer incident;

  SoccerIncidentBox({Key ?key, required this.incident}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHomeTeam = homeTeamStat(incident);
    return

      Align(
          alignment: isHomeTeam  ? Alignment.centerLeft : Alignment.centerRight,
        child:

        DecoratedBox(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1),
        shape: BoxShape.rectangle
      ),

      child:

          Padding(
          padding: const EdgeInsets.all(6),
          child:
          StatIncidentPictureWithText(statistic : incident),
          )
        )

    );
  }
  //
  // imageFromStatistic() {
  //   String incident_type = incident.incident_type;
  //   if ("substitution" == incident_type){
  //     return Image.network(
  //       incident.player?.photo ?? Constants.noImageUrl,
  //       width: 36,
  //       height: 36
  //     );
  //   }
  //
  //   IconData icon = Icons.not_interested;
  //   if ("card" == incident_type){
  //     if (incident.card_type ==  "Yellow") {
  //       icon = Icons.add_card;
  //     }else{
  //       icon = Icons.error;
  //     }
  //   }else if ("goal" == incident_type){
  //     icon = Icons.sports_soccer;
  //   }else if ("period" == incident_type){
  //     icon = Icons.star;
  //   }else{
  //     icon = Icons.error;
  //   }
  //
  //   return Icon(
  //     icon,
  //     size: 24,
  //   );
  //
  // }

  // String textFor(MatchEventIncidentSoccer statistic) {
  //   String incident_type = statistic.incident_type;
  //   if ("substitution" == incident_type){
  //     return '${statistic.time}\' ${statistic.player?.name_short}\n(${statistic.player_two_in?.name_short})';
  //   }
  //
  //   return '${statistic.time}\' ${statistic.player?.name_short}';
  // }

  homeTeamStat(MatchEventIncidentSoccer statistic) {
    bool home =  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
    return home;
  }

}