import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';

import '../models/constants/ColorConstants.dart';
import '../utils/cache/CustomCacheManager.dart';

class StatIncidentPictureWithText extends StatelessWidget{

  final MatchEventIncidentSoccer statistic;

  StatIncidentPictureWithText({required this.statistic});

  @override
  Widget build(BuildContext context) {

    bool isHomeTeam = homeTeamStat(statistic);

    return

    Wrap(

    children:[


      Row(
    children: [

        !isHomeTeam ?
    //    Expanded(flex: 2, child:
        Text(textFor(statistic, isHomeTeam), maxLines: 2, overflow: TextOverflow.clip, textAlign: TextAlign.right,  style: const TextStyle(color: Color(ColorConstants.my_dark_grey), fontStyle: FontStyle.italic, fontSize: 11),)
   // )
              : const SizedBox(width: 0,),

      !isHomeTeam ? const SizedBox(width: 4,) : const SizedBox(width: 0,),

       Align(alignment: Alignment.center, child:
        secondaryImageFromStatistic(),
        ),

      Align(alignment: Alignment.center, child:
      playerImageFromStatistic(),
      ),

      !isHomeTeam ? const SizedBox(width: 0,) : const SizedBox(width: 4,),

        isHomeTeam ?
        //Expanded(flex: 2, child:
        Text(textFor(statistic, isHomeTeam), maxLines: 2, overflow: TextOverflow.clip, textAlign: TextAlign.right,  style: const TextStyle(color: Color(ColorConstants.my_dark_grey), fontStyle: FontStyle.italic, fontSize: 11),)
          //)
            : const SizedBox(width: 0,),

    ])
    ]
    );


  }

  secondaryImageFromStatistic() {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){

      return const Icon(
        Icons.change_circle_rounded,  // Built-in Flutter icon
        size: 16,  // Icon size
        color: Color(ColorConstants.my_green), // Icon color
      );

     }

    if ("varDecision" == incident_type){

      return const Icon(
        Icons.block,  // Built-in Flutter icon
        size: 16,  // Icon size
        color: Colors.red, // Icon color
      );

    }


    if("inGamePenalty" == incident_type){
      return const Icon(
        Icons.error,  // Built-in Flutter icon
        size: 16,  // Icon size
        color: Colors.red, // Icon color
      );
    }


    IconData icon = Icons.change_circle_rounded;
    if ("card" == incident_type){

      if ("Yellow" == statistic.card_type) {
        return Container(
          width: 12,  // You can adjust the width of the card
          height: 16, // You can adjust the height of the card
          decoration: const BoxDecoration(
            color: Colors.yellow, // Yellow color for the yellow card
            borderRadius: BorderRadius.all(Radius.circular(5.0)), // Rounded corners (optional)
          ),
        );

        return Image.asset(
          'assets/images/yellowcard.png', width: 16, height: 16,);
      }else if ("YellowRed" == statistic.card_type){
        return Image.asset(
          'assets/images/red_yellow_card.png', width: 16, height: 16,);
      }else if ("Red" == statistic.card_type){
        return Container(
          width: 12,  // You can adjust the width of the card
          height: 16, // You can adjust the height of the card
          decoration: const BoxDecoration(
            color: Colors.red, // Yellow color for the yellow card
            borderRadius: BorderRadius.all(Radius.circular(5.0)), // Rounded corners (optional)
          ),
        );
      }
      
      icon = Icons.add_card;
    }

    if ("goal" == incident_type){
      return  const Icon(
        Icons.sports_soccer,  // Built-in Flutter icon
        size: 16,  // Icon size
        color: Color(ColorConstants.my_dark_grey), // Icon color
      );
    }

    //SHOULD NOT HAPPEN
    if ("period" == incident_type || "injuryTime" == incident_type){
      icon = Icons.star;
    }

    return Icon(
      icon,
      size: 16,

    );

  }

  homeTeamStat(MatchEventIncidentSoccer statistic) {
    bool home =  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
    return home;
  }

  String textFor(MatchEventIncidentSoccer statistic, bool isHomeTeam) {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){
      return '${statistic.time}\' ${statistic.player?.name_short} (${statistic.player_two_in?.name_short})';
    }

    String text = '${statistic.time}\' ${statistic.player?.name}';
    if ("goal" == incident_type){
      if ("penalty" == statistic.text){
        text += ' (penalty)';
      }

      if (isHomeTeam){
        text += '(${statistic.home_score}-${statistic.away_score})';
      }else{
        text = '(${statistic.home_score}-${statistic.away_score})$text';
      }

    }

    if("varDecision" == incident_type){
      text = '[VAR] $text';
    }

    if("inGamePenalty" == incident_type){
      text += ' (penalty ${statistic.reason})';
    }

    return text;
  }

  playerImageFromStatistic() {
    return CachedNetworkImage(
      cacheManager: CustomCacheManager(),
      imageUrl: statistic.player?.photo ?? "https://xscore.cc/resb/no-photo.png",
      height: 16,
      width: 16,
    );
  }
}