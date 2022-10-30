import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';
import 'LogoWithTeam.dart';
import 'LogoWithTeamName.dart';

class UpcomingMatchRow extends StatefulWidget {

  //UserPrediction? selectedPrediction;

  //List<UserPrediction> selectedOdds = <UserPrediction>[];

  MatchEvent gameWithOdds;

  Function( int, UserPrediction?) ?callbackForOdds;

  // Function ?callbackForEvents;

  UpcomingMatchRow({Key ?key, required this.gameWithOdds, required this.callbackForOdds}) : super(key: key);

  @override
  UpcomingMatchRowState createState() => UpcomingMatchRowState(gameWithOdds: gameWithOdds, callbackForOdds: callbackForOdds);
}

  class UpcomingMatchRowState extends State<UpcomingMatchRow> {

    UserPrediction? selectedPrediction;

    // List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function( int, UserPrediction?) ?callbackForOdds;

    // Function ?callbackForEvents;

    MatchEvent gameWithOdds;

    UpcomingMatchRowState({
      // required this.selectedOdds,
      required this.gameWithOdds,
      // required this.callbackForEvents,
      required this.callbackForOdds
    });


    @override
    Widget build(BuildContext context) {

      if (gameWithOdds.homeTeam.name.contains("Arsenal")) {
        print('ARSENAL BUILDING MATCH ROW');
      }

      return

      Wrap(//top parent
          spacing: 5,
        children: [

        DecoratedBox(//first child
            decoration: BoxDecoration(color: Colors.white),
            child:
            Row( //top father
                mainAxisSize: MainAxisSize.max,
                children: [
                  // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                  Expanded( //first column
                      flex: 10,
                      child:

                          Column(
                              children: [
                              Align(
                              alignment: Alignment.centerLeft,
                              child:
                                LogoWithTeamName(key: UniqueKey(),
                                    team: gameWithOdds.homeTeam)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:

                                LogoWithTeamName(key: UniqueKey(),
                                    team: gameWithOdds.awayTeam)),
                              ]
                          )), // FIRST COLUMN END

                  Expanded(
                      flex: 2,
                      child:

                      Column( //second column
                          children: [
                            Padding(padding: EdgeInsets.all(6), child:
                            Text( (gameWithOdds.startHour! < 10 ? '0' : '' ) + gameWithOdds.startHour!.toString()  +
                                (gameWithOdds.startMinute! < 10 ? '0' : '' ) + gameWithOdds.startMinute!.toString() ,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),))
                          ]
                      )), //SECOND COLUMN END

                  //RD COLUMN END


                ])), //parent column end

          //ODDS ROW

     if (gameWithOdds.odds.odd1.value > -1)
          Row(mainAxisSize: MainAxisSize.max,

            children: [
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selected: selectedPrediction,
                        eventId: gameWithOdds.eventId,
                        predictionText: '1:',
                        callbackForOdds: update,
                        prediction: gameWithOdds.odds.odd1,
                        toRemove: [
                          gameWithOdds.odds.odd2,
                          gameWithOdds.odds.oddX
                        ],))),
              Expanded(flex: 4,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selected: selectedPrediction,
                        eventId: gameWithOdds.eventId,
                        predictionText: 'X:',
                        callbackForOdds: update,
                        prediction: gameWithOdds.odds.oddX,
                        toRemove: [
                          gameWithOdds.odds.odd2,
                          gameWithOdds.odds.odd1
                        ],))),
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(4),
                      child: GestureDetectorForOdds(
                        key: UniqueKey(),
                        selected: selectedPrediction,
                        eventId: gameWithOdds.eventId,
                        predictionText: '2:',
                        callbackForOdds: update,
                        prediction: gameWithOdds.odds.odd2,
                        toRemove: [
                          gameWithOdds.odds.odd1,
                          gameWithOdds.odds.oddX
                        ],)))
            ],
          ),

        ]
      );

    }

    update(UserPrediction? prediction){
      callbackForOdds?.call(gameWithOdds.eventId, prediction);

      setState(() {
         selectedPrediction = prediction;
      });
    }

  }
