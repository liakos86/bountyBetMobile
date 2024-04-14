import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/notification/NotificationInfo.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import 'package:flutter_app/utils/notification/NotificationService.dart';
import '../../models/Score.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';

class LiveMatchRow extends StatefulWidget {

  final MatchEvent gameWithOdds;


  LiveMatchRow({Key ?key, required this.gameWithOdds}) : super(key: key);

  @override
  LiveMatchRowState createState() => LiveMatchRowState();
}

class LiveMatchRowState extends State<LiveMatchRow> {

  late MatchEvent gameWithOdds;

  @override
  void initState() {
    super.initState();
    gameWithOdds = widget.gameWithOdds;
}


  @override
  Widget build(BuildContext context) {

    int homeRed = 0;
    int awayRed = 0;

    Iterable<MatchEventIncidentsSoccer> redCards = gameWithOdds.incidents.where((element) =>
      element.incident_type=="card" && (element.card_type=='Red' || element.card_type=='YellowRed'));

    for (MatchEventIncidentsSoccer redCard in redCards){
      if (redCard.player_team==1){
        ++homeRed;
      }else if (redCard.player_team==2){
        ++awayRed;
      }
    }

    return
      DecoratedBox(

          decoration: BoxDecoration(color: gameWithOdds.changeEvent == ChangeEvent.NONE ? Colors.white : ( ChangeEvent.isGoal(gameWithOdds.changeEvent) ? Colors.red.shade50 : Colors.blue[200]),
              border: Border(
              top: BorderSide(width: 0.3, color: Colors.grey.shade600),
              left: const BorderSide(width: 0, color: Colors.transparent),
                right: const BorderSide(width: 0, color: Colors.transparent),
                bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
                ), ),

          child:

          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [

                Expanded(//first column
                    flex: MatchEventStatus.INPROGRESS.statusStr== gameWithOdds.status ? 2 : 0,
                    child:

                    MatchEventStatus.INPROGRESS.statusStr== gameWithOdds.status ?

                    GestureDetector(
                        onTap: () async =>{

                          if (await NotificationService.checkPermission()){

                            //if (await sharedPrefs.isFavEvent(gameWithOdds.eventId.toString())){
                            if (gameWithOdds.isFavourite){
                              sharedPrefs.removeFavEvent(gameWithOdds.eventId.toString()),
                              updateFav(false)
                            } else{
                              sharedPrefs.appendEventId(gameWithOdds.eventId.toString()),
                              updateFav(true)
                              },
                         }
                        },
                        child:
                    Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child:
                                gameWithOdds.isFavourite?
                                const Icon(Icons.star_outlined)
                                    :
                            const Icon(Icons.star_border),
                          )
                        ]
                    )) :

                        const SizedBox(width: 0,)
                ),

                Expanded(//first column
                    flex: 10,
                    child:

                GestureDetector(
                onTap: () {

                Navigator.push(
                context,
                MaterialPageRoute(
                // maintainState: false,
                builder:  (context) =>
                // StatefulBuilder(
                //  key: UniqueKey(),

                //  builder: (BuildContext context, StateSetter setState) =>
                MatchInfoSoccerDetailsPage(key: UniqueKey(), event: gameWithOdds, eventCallback: getEvent)
                )
                //),
                );
                },
                child:

                    Column(
                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.homeTeam.getLocalizedName(), logoUrl: gameWithOdds.homeTeam.logo, redCards: homeRed, logoSize: 24, fontSize: 14,),
                        ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                      LogoWithName(key: UniqueKey(), name: gameWithOdds.awayTeam.getLocalizedName(), logoUrl: gameWithOdds.awayTeam.logo, redCards: awayRed, logoSize: 24, fontSize: 14,),
                            )
                    ]
                ))),
      //), // FIRST COLUMN END

                Expanded(
                    flex: 4,
                    child:

                Column(//second column
                    children: [
                     Padding(padding: EdgeInsets.all(6), child:
                      Text(
                       (gameWithOdds.display_status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),))
                    ]
                )),//SECOND COLUMN END

                Expanded(
                    flex: 2,

                    child:

                Column(// third column
                    children: [
                      Padding(padding: const EdgeInsets.all(6), child:
                      Text(textScoreFrom(gameWithOdds.homeTeamScore), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? 13 : 12,
                          fontWeight:  FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? Colors.redAccent : Colors.black87),)),

                      Padding(padding: EdgeInsets.all(8), child:
                      Text(textScoreFrom(gameWithOdds.awayTeamScore), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? 13 : 12,
                          fontWeight: FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.redAccent : Colors.black87),)),
                    ]
                )), //THIRD COLUMN END

              ])//parent column end

      );
  }

  String textScoreFrom(Score ?score) {
    if (score == null){
      return '-';
    }

    if (score.current == null){
      return '-';
    }

    return score.current.toString();

  }

  getEvent(){
    return gameWithOdds;
  }

  updateFav(bool newfav) {
    setState(() {
      gameWithOdds.isFavourite = newfav;
    });
  }

}


