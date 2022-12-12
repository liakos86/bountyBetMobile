import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/match_event.dart';

class MatchScoreMiddleText extends StatelessWidget{

  MatchEvent event;

  MatchScoreMiddleText({required this.event});

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Text('${event.startHour.toString() + ':'+ event.startMinute.toString()}'),
        Text(scoreText(event), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),),
        Text(event.status_for_client.toString()),


      ],



    );


  }

  String scoreText(MatchEvent event) {
    return '${event.homeTeamScore?.current} - ${event.awayTeamScore?.current}';
  }

}