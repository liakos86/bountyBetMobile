import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';

class StatPictureInPicture extends StatelessWidget{

  MatchEventIncidentsSoccer statistic;

  StatPictureInPicture({required this.statistic});

  @override
  Widget build(BuildContext context) {

    return

    Container(

    width: 40,
      height:40,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blueAccent, width: 1),


      ),


      child:

          Padding(padding: EdgeInsets.all(2),
child:
      Stack(
      // fit: StackFit.passthrough,

      children: [

        Positioned(top: 0, left: 0, child: imageFromStatistic()),

        Positioned(bottom: 0, right: 0, child: secondaryImageFromStatistic())


      ],

    )));


  }

  imageFromStatistic() {
    String incident_type = statistic.incident_type;
    if ("substitution" == incident_type || "card" == incident_type
    || "goal" == incident_type){
      return Image.network(
          statistic.player?.photo ?? "https://tipsscore.com/resb/no-photo.png",
          width: 36,
          height: 36
      );
    }

    IconData icon = Icons.not_interested;

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
      return Image.asset('assets/images/yellow_card.png', width: 16, height: 16,);
      
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

}