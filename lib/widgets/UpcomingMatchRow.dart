import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';

class UpcomingMatchRow extends StatefulWidget {

  MatchEvent gameWithOdds;

  Function(List<UserPrediction>) ?callback;

  UpcomingMatchRow({
    required this.gameWithOdds,
    required this.callback
  });

  @override
  UpcomingMatchRowState createState() => UpcomingMatchRowState(gameWithOdds: gameWithOdds, callback: callback);
}

  class UpcomingMatchRowState extends State<UpcomingMatchRow>{

    Function(List<UserPrediction>) ?callback;

    MatchEvent gameWithOdds;

    UpcomingMatchRowState({
      required this.gameWithOdds,
      required this.callback
    });


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(mainAxisSize: MainAxisSize.max,

        children: [
          Expanded( flex : 3, child: Padding(padding: EdgeInsets.all(8), child :Text(gameWithOdds.homeTeam, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right))),
          Expanded( flex : 1, child: Padding(padding: EdgeInsets.all(8), child : Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center))),
          Expanded( flex : 3, child: Padding(padding: EdgeInsets.all(8), child : Text(gameWithOdds.awayTeam, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.left))),


        ],),

        Row(mainAxisSize: MainAxisSize.max,

          children: [
            Expanded( flex : 5, child: Padding(padding: EdgeInsets.all(8), child : GestureDetectorForOdds(align: TextAlign.right, eventId: gameWithOdds.eventId, callback: callback, prediction: gameWithOdds.odds.odd1, toRemove: [gameWithOdds.odds.odd2, gameWithOdds.odds.oddX],))),
            Expanded( flex : 2, child: Padding(padding: EdgeInsets.all(8), child : GestureDetectorForOdds(align: TextAlign.center, eventId: gameWithOdds.eventId, callback: callback, prediction: gameWithOdds.odds.oddX, toRemove: [gameWithOdds.odds.odd2, gameWithOdds.odds.odd1],))),
            Expanded( flex : 5, child: Padding(padding: EdgeInsets.all(8), child : GestureDetectorForOdds(align: TextAlign.left, eventId: gameWithOdds.eventId, callback: callback, prediction: gameWithOdds.odds.odd2, toRemove: [gameWithOdds.odds.odd1, gameWithOdds.odds.oddX],)))
          ],),


        Row(mainAxisSize: MainAxisSize.max,

          children: [
            Expanded( flex : 1, child: Padding(padding: EdgeInsets.all(8), child : GestureDetectorForOdds(align: TextAlign.right, eventId: gameWithOdds.eventId, callback: callback, prediction: gameWithOdds.odds.oddO25, toRemove: [gameWithOdds.odds.oddU25],))),
            Expanded( flex : 1, child: Padding(padding: EdgeInsets.all(8), child : GestureDetectorForOdds(align: TextAlign.left, eventId: gameWithOdds.eventId, callback: callback, prediction: gameWithOdds.odds.oddU25, toRemove: [gameWithOdds.odds.oddO25],))),


          ],),

        Divider(color: Colors.blueAccent, height: 4, thickness: 0.5,),


      ]

    );




  return Container(padding: EdgeInsets.all(20),
  child: ListTile(title: Text(
  gameWithOdds.homeTeam + ' - ' + gameWithOdds.awayTeam,
  style: TextStyle(fontSize: 18.0)),
  leading: Column(

  children: [
  Expanded(flex: 1, child: GestureDetector(onTap: () {
  if (OddsPage.selectedOdds.contains(gameWithOdds.odds.odd1)) {
  setState(() {
  OddsPage.selectedGames.remove(gameWithOdds.eventId);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd1);
  });
  } else {
  setState(() {
  OddsPage.selectedGames.add(gameWithOdds.eventId);
  OddsPage.selectedOdds.add(gameWithOdds.odds.odd1);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.oddX);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd2);
  });
  }

  callback?.call(OddsPage.selectedOdds);
  },
  child: Container(
  color: OddsPage.selectedOdds.contains(gameWithOdds.odds.odd1)
  ? Colors.green
      : Colors.white,
  child: Text('1: ' + gameWithOdds.odds.odd1.value.toStringAsFixed(2))))),


  Expanded(flex: 1, child: GestureDetector(onTap: () {
  if (OddsPage.selectedOdds.contains(gameWithOdds.odds.oddX)) {
  setState(() {
  OddsPage.selectedGames.remove(gameWithOdds.eventId);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.oddX);
  });
  } else {
  setState(() {
  OddsPage.selectedGames.add(gameWithOdds.eventId);
  OddsPage.selectedOdds.add(gameWithOdds.odds.oddX);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd1);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd2);
  });
  }

  callback?.call(OddsPage.selectedOdds);
  },

  child: Container(
  color: OddsPage.selectedOdds.contains(gameWithOdds.odds.oddX)
  ? Colors.green
      : Colors.white,
  child: Text('X: ' + gameWithOdds.odds.oddX.value.toStringAsFixed(2))))),


  Expanded(flex: 1, child: GestureDetector(
  onTap: () {
  if (OddsPage.selectedOdds.contains(gameWithOdds.odds.odd2)) {
  setState(() {
  OddsPage.selectedGames.remove(gameWithOdds.eventId);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd2);
  });
  } else {
  setState(() {
  OddsPage.selectedGames.add(gameWithOdds.eventId);
  OddsPage.selectedOdds.add(gameWithOdds.odds.odd2);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.oddX);
  OddsPage.selectedOdds.remove(gameWithOdds.odds.odd1);
  });
  }

  callback?.call(OddsPage.selectedOdds);
  },


  child: Container(
  color: OddsPage.selectedOdds.contains(gameWithOdds.odds.odd2)
  ? Colors.green
      : Colors.white,
  child: Text('2: ' + gameWithOdds.odds.odd2.value.toStringAsFixed(2))))),
  ],

  ),
  ));
  }


  }


