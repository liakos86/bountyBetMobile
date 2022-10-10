import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/OddsPage.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';
import 'LogoWithTeam.dart';

class UpcomingMatchRow extends StatefulWidget {

  MatchEvent gameWithOdds;

  Function(List<UserPrediction>) ?callback;

  UpcomingMatchRow({Key ?key, required this.gameWithOdds}) : super(key: key);

  @override
  UpcomingMatchRowState createState() => UpcomingMatchRowState(gameWithOdds: gameWithOdds, callback: callback);
}

  class UpcomingMatchRowState extends State<UpcomingMatchRow> {

    Function(List<UserPrediction>) ?callback;

    MatchEvent gameWithOdds;

    UpcomingMatchRowState({
      required this.gameWithOdds,
      required this.callback
    });


    @override
    Widget build(BuildContext context) {
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
                      flex: 6,
                      child:

                      Align(
                          alignment: Alignment.centerLeft,
                          child:

                          Column(

                              children: [

                                LogoWithTeam(key: UniqueKey(),
                                    team: gameWithOdds.homeTeam),

                                LogoWithTeam(key: UniqueKey(),
                                    team: gameWithOdds.awayTeam),

                              ]

                          ))), // FIRST COLUMN END

                  Expanded(
                      flex: 2,
                      child:

                      Column( //second column
                          children: [
                            Padding(padding: EdgeInsets.all(6), child:
                            Text((gameWithOdds.startHour!.toString() + ':' + (gameWithOdds.startMinute! < 10 ? '0' : '')  +
                                gameWithOdds.startMinute!.toString()),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),))
                          ]
                      )), //SECOND COLUMN END

                  //RD COLUMN END


                ])), //parent column end

          //ODDS ROW

     if (gameWithOdds.odds.odd1.value > -1) DecoratedBox(//second child

      decoration: BoxDecoration(color: Colors.yellow[200]),
      child:
          Row(mainAxisSize: MainAxisSize.max,

            children: [
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(8),
                      child: GestureDetectorForOdds(align: TextAlign.right,
                        eventId: gameWithOdds.eventId,
                        callback: callback,
                        prediction: gameWithOdds.odds.odd1,
                        toRemove: [
                          gameWithOdds.odds.odd2,
                          gameWithOdds.odds.oddX
                        ],))),
              Expanded(flex: 2,
                  child: Padding(padding: EdgeInsets.all(8),
                      child: GestureDetectorForOdds(align: TextAlign.center,
                        eventId: gameWithOdds.eventId,
                        callback: callback,
                        prediction: gameWithOdds.odds.oddX,
                        toRemove: [
                          gameWithOdds.odds.odd2,
                          gameWithOdds.odds.odd1
                        ],))),
              Expanded(flex: 5,
                  child: Padding(padding: EdgeInsets.all(8),
                      child: GestureDetectorForOdds(align: TextAlign.left,
                        eventId: gameWithOdds.eventId,
                        callback: callback,
                        prediction: gameWithOdds.odds.odd2,
                        toRemove: [
                          gameWithOdds.odds.odd1,
                          gameWithOdds.odds.oddX
                        ],)))
            ],
          ),


        )
        ]
      )

        ;


      return Column(
          children: [

            Row(mainAxisSize: MainAxisSize.max,

              children: [
                Expanded(
                    flex: 3, child: Padding(padding: EdgeInsets.all(8), child:

                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(child: Image.network(
                        gameWithOdds.homeTeam.logo,
                        height: 24,
                        width: 24,
                      )),
                      TextSpan(text: gameWithOdds.homeTeam.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),


                    ],
                  ),
                )

                  //Text(gameWithOdds.homeTeam.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)


                )),
                Expanded(flex: 1,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: Text("-", style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.center))),


                Expanded(
                    flex: 3, child: Padding(padding: EdgeInsets.all(8), child:

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: gameWithOdds.awayTeam.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      WidgetSpan(child: Image.network(
                        gameWithOdds.awayTeam.logo,
                        height: 24,
                        width: 24,
                      )),


                    ],
                  ),
                )

                  //     Text(gameWithOdds.awayTeam.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.left)


                )),


              ],),

            Row(mainAxisSize: MainAxisSize.max,

              children: [
                Expanded(flex: 5,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: GestureDetectorForOdds(align: TextAlign.right,
                          eventId: gameWithOdds.eventId,
                          callback: callback,
                          prediction: gameWithOdds.odds.odd1,
                          toRemove: [
                            gameWithOdds.odds.odd2,
                            gameWithOdds.odds.oddX
                          ],))),
                Expanded(flex: 2,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: GestureDetectorForOdds(align: TextAlign.center,
                          eventId: gameWithOdds.eventId,
                          callback: callback,
                          prediction: gameWithOdds.odds.oddX,
                          toRemove: [
                            gameWithOdds.odds.odd2,
                            gameWithOdds.odds.odd1
                          ],))),
                Expanded(flex: 5,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: GestureDetectorForOdds(align: TextAlign.left,
                          eventId: gameWithOdds.eventId,
                          callback: callback,
                          prediction: gameWithOdds.odds.odd2,
                          toRemove: [
                            gameWithOdds.odds.odd1,
                            gameWithOdds.odds.oddX
                          ],)))
              ],),


            Row(mainAxisSize: MainAxisSize.max,

              children: [
                Expanded(flex: 1,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: GestureDetectorForOdds(align: TextAlign.right,
                          eventId: gameWithOdds.eventId,
                          callback: callback,
                          prediction: gameWithOdds.odds.oddO25,
                          toRemove: [gameWithOdds.odds.oddU25],))),
                Expanded(flex: 1,
                    child: Padding(padding: EdgeInsets.all(8),
                        child: GestureDetectorForOdds(align: TextAlign.left,
                          eventId: gameWithOdds.eventId,
                          callback: callback,
                          prediction: gameWithOdds.odds.oddU25,
                          toRemove: [gameWithOdds.odds.oddO25],))),


              ],),

            Divider(color: Colors.blueAccent, height: 4, thickness: 0.5,),


          ]

      );
    }
  }
