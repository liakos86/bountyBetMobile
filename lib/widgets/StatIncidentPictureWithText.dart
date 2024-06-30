import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';

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
        Text(textFor(statistic), maxLines: 2, overflow: TextOverflow.clip, textAlign: TextAlign.right,  style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 11),)
   // )
              : const SizedBox(width: 0,),

      !isHomeTeam ? const SizedBox(width: 4,) : const SizedBox(width: 0,),

       Align(alignment: Alignment.center, child:
        secondaryImageFromStatistic(),
        ),

      !isHomeTeam ? const SizedBox(width: 0,) : const SizedBox(width: 4,),

        isHomeTeam ?
        //Expanded(flex: 2, child:
        Text(textFor(statistic), maxLines: 2, overflow: TextOverflow.clip, textAlign: TextAlign.right,  style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 11),)
          //)
            : const SizedBox(width: 0,),

    ])
    ]
    );


  }

  // imageFromStatistic() {
  //   String incident_type = statistic.incident_type;
  //   if ("substitution" == incident_type || "card" == incident_type
  //   || "goal" == incident_type){
  //     return Image.network(
  //         statistic.player?.photo ?? "https://tipsscore.com/resb/no-photo.png",
  //         // width: 36,
  //         // height: 36
  //     );
  //   }

  //   IconData icon = Icons.not_interested;
  //
  //   if ("period" == incident_type){
  //     icon = Icons.star;
  //   }
  //
  //   if ("injuryTime" == incident_type){
  //     icon = Icons.call_end;
  //   }
  //
  //   return Icon(
  //     icon,
  //     size: 24,
  //   );
  //
  //   return Icons.question_mark;
  //
  // }

  secondaryImageFromStatistic() {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){
    //   return Image.network(
    //       statistic.player_two_in?.photo ?? "https://tipsscore.com/resb/no-photo.png",
    //       width: 18,
    //       height: 18
    //   );
      return Image.asset('assets/images/substitution.png', width: 16, height: 16,);
    }

    IconData icon = Icons.change_circle_rounded;
    if ("card" == incident_type){

      if ("Yellow" == statistic.card_type) {
        return Image.asset(
          'assets/images/yellowcard.png', width: 16, height: 16,);
      }else if ("YellowRed" == statistic.card_type){
        return Image.asset(
          'assets/images/red_yellow_card.png', width: 16, height: 16,);
      }else if ("Red" == statistic.card_type){
        return Image.asset(
          'assets/images/redcard.png', width: 16, height: 16,);
      }
      
      icon = Icons.add_card;
    }

    if ("goal" == incident_type){
      return Image.asset('assets/images/goal.png', width: 16, height: 16,);
      // icon = Icons.sports_soccer;
    }

    if ("period" == incident_type){
      icon = Icons.star;
    }

    if ("injuryTime" == incident_type){
      icon = Icons.call_end;
    }

    return Icon(
      icon,
      size: 16,

    );

    return Icons.question_mark;

  }

  homeTeamStat(MatchEventIncidentSoccer statistic) {
    bool home =  statistic.player_team == 1 ||
        statistic.scoring_team ==1;
    return home;
  }

  String textFor(MatchEventIncidentSoccer statistic) {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type){
      return '${statistic.time}\' ${statistic.player?.name_short}\n(${statistic.player_two_in?.name_short})';
    }

    String text = '${statistic.time}\' ${statistic.player?.name}';
    if ("goal" == incident_type){
      if ("penalty" == statistic.text){
        text += ' (penalty)';
      }
    }

    return text;
  }
}