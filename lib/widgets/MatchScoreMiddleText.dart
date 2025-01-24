import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/Score.dart';

class MatchScoreMiddleText extends StatefulWidget {

  final MatchEvent event;

  MatchScoreMiddleText({Key? key, required this.event}) : super(key: key);

  @override
  MatchScoreMiddleTextState createState() =>
      MatchScoreMiddleTextState();
}

  class MatchScoreMiddleTextState extends State<MatchScoreMiddleText>{

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  late MatchEvent event;

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Text(event.start_at_local),// + ':'+ event.startMinute.toString()}'),
        Text(scoreText(event), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30),),
        Text(event.display_status),


      ],



    );


  }

  String scoreText(MatchEvent event) {
    return '${event.homeTeamScore?.current} - ${event.awayTeamScore?.current}';
  }

}