import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/ChangeEvent.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:flutter_app/pages/MatchInfoSoccerDetailsPage.dart';
import '../../enums/BetPredictionType.dart';
import '../../enums/MatchEventStatusMore.dart';
import '../../enums/WinnerType.dart';
import '../../helper/SharedPrefs.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/match_event.dart';
import '../../pages/ParentPage.dart';
import '../../utils/BetUtils.dart';
import '../DisplayOdd.dart';
import '../LogoWithName.dart';

class LiveMatchRowTilted extends StatefulWidget {

  final MatchEvent gameWithOdds;


  LiveMatchRowTilted({Key ?key, required this.gameWithOdds}) : super(key: key);

  @override
  LiveMatchRowTiltedState createState() => LiveMatchRowTiltedState();
}

class LiveMatchRowTiltedState extends State<LiveMatchRowTilted> {

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



    // Iterable<MatchEventIncidentSoccer> redCards = gameWithOdds.st.where((element) =>
    //   element.incident_type=="card" && (element.card_type=='Red' || element.card_type=='YellowRed'));
    //
    // for (MatchEventIncidentSoccer redCard in redCards){
    //   if (redCard.player_team==1){
    //     ++homeRed;
    //   }else if (redCard.player_team==2){
    //     ++awayRed;
    //   }
    // }

    return


          Row(//top father
              mainAxisSize: MainAxisSize.max,
              children: [

                Expanded(//second column
                    flex:flexSizeForLeading()
                   ,
                    child:
                    ( MatchEventStatus.INPROGRESS.statusStr == gameWithOdds.status || MatchEventStatus.NOTSTARTED.statusStr == gameWithOdds.status ) ?
                _buildTiltedFavourite()
                        :

                    (gameWithOdds.odds != null &&  gameWithOdds.winnerCodeNormalTime != null) ?
                        SizedBox(height:60, child:
              _buildWinnerOdds(gameWithOdds.odds, gameWithOdds.winnerCodeNormalTime)
                        )

                  :
              const SizedBox(height:42)
                ),



                Expanded(//second column
                    flex: 14,
                    child:

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 4),
                        //   child:

                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                onTap: () {

                  if (gameWithOdds.status != MatchEventStatus.INPROGRESS.statusStr && gameWithOdds.status != MatchEventStatus.FINISHED.statusStr){
                    return;
                  }

                Navigator.push(
                context,
                MaterialPageRoute(

                    builder:  (context) =>

                        MatchInfoSoccerDetailsPage(key: UniqueKey(),
                            event: gameWithOdds,
                            eventCallback: getEvent)


                )
                );
                },
                child:

                    Column(
                    children: [
                        Align(
                        alignment: Alignment.centerLeft,
                        child:
                      LogoWithName(key: UniqueKey(), isHomeTeam: true, name: gameWithOdds.homeTeam.getLocalizedName(), logoUrl: gameWithOdds.homeTeam.logo, redCards: homeRed, logoSize: 20, fontSize: 12,  winnerType: BetUtils.calculateWinnerType(gameWithOdds), goalScored: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ),
                        ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                      LogoWithName(key: UniqueKey(), isHomeTeam: false, name: gameWithOdds.awayTeam.getLocalizedName(), logoUrl: gameWithOdds.awayTeam.logo, redCards: awayRed, logoSize: 20, fontSize: 12,  winnerType: BetUtils.calculateWinnerType(gameWithOdds), goalScored: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL),
                            )
                      ]
                    )
                )
                        // )
                        // )
                ),

                Expanded(
                    flex: 3,
                    child:

                Column(//second column
                    children: [
                     Padding(padding: const EdgeInsets.all(6), child:
                      Text(
                       (gameWithOdds.display_status),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),))
                    ]
                )),//SECOND COLUMN END

                Expanded(
                    flex: flexSizeForTrailing(),

                    child:

                   // (MatchEventStatus.fromStatusText(gameWithOdds.status) == MatchEventStatus.INPROGRESS) ?

                Column(// third column
                    children: [
                      Padding(padding: const EdgeInsets.all(6), child:

                      Text(gameWithOdds.textScore(true), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? 13 : 12,
                          fontWeight:  FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.HOME_GOAL ? Colors.redAccent : Colors.white),)),

                      Padding(padding: const EdgeInsets.all(6), child:
                      Text(gameWithOdds.textScore(false), style: TextStyle(
                          fontSize: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? 13 : 12,
                          fontWeight: FontWeight.w900,
                          color: gameWithOdds.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.redAccent : Colors.white),)),
                    ]
                )

               // : Container()

                ), //THIRD COLUMN END

              ]
          // )//parent column end

      );
  }



  getEvent(){
    return gameWithOdds;
  }

  _buildTiltedFavourite() {

      return
        Transform(
            transform: Matrix4.skewX(-0.2), // Tilt the container
            child: Container(
                margin: const EdgeInsets.only(left:6),
                //padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    // Background color of the parallelogram
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.black87, width: 1)
                ),
                child:


                GestureDetector(
                    onTap: () async =>
                    {

                      if ((await checkFirebasePermission())
                          .authorizationStatus ==
                          AuthorizationStatus.authorized){

                        if (gameWithOdds.isFavourite){
                          sharedPrefs.removeFavEvent(
                              gameWithOdds.eventId.toString()),
                          updateFav(false)
                        } else
                          {
                            sharedPrefs.appendEventId(
                                gameWithOdds.eventId.toString()),
                            updateFav(true)
                          },
                        ParentPageState.favouritesUpdate(),
                      }
                    },

                    child:
                    Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child:
                            gameWithOdds.isFavourite ?
                            const Icon(Icons.star_outlined, color: Colors.redAccent)
                                :
                            const Icon(Icons.star_border, color: Color(ColorConstants.my_dark_grey)),
                          )
                        ]
                    )
                )
            )
        );

  }

  Future<NotificationSettings> checkFirebasePermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    return await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  updateFav(bool newfav) {
    setState(() {
      gameWithOdds.isFavourite = newfav;
    });
  }

  _buildWinnerOdds(MatchOdds? odds, int? winner_code) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex:1, child:
        DisplayOdd(betPredictionType: BetPredictionType.HOME_WIN, prediction: winnerPredictionType(winner_code), odd: odds!.odd1)
        ),
        Expanded(flex:1, child:
        DisplayOdd(betPredictionType: BetPredictionType.DRAW, prediction: winnerPredictionType(winner_code), odd: odds!.oddX)
        ),
        Expanded(flex:1, child:
        DisplayOdd(betPredictionType: BetPredictionType.AWAY_WIN, prediction: winnerPredictionType(winner_code), odd: odds!.odd2)
        ),

      ]

    );
  }

  winnerPredictionType(int? winner_code) {
    if (winner_code == 1){
      return BetPredictionType.HOME_WIN;
    }

    if (winner_code == 2){
      return BetPredictionType.AWAY_WIN;
    }

    if (winner_code == 3){
      return BetPredictionType.DRAW;
    }

    return BetPredictionType.OVER_25;
  }

  flexSizeForLeading() {
    if ( MatchEventStatus.INPROGRESS.statusStr == gameWithOdds.status || MatchEventStatus.NOTSTARTED.statusStr == gameWithOdds.status ){
      return 3;
    }

    if  (gameWithOdds.odds != null &&  gameWithOdds.winnerCodeNormalTime != null){
      return 3;
    }

    return 0;
  }

  flexSizeForTrailing() {
    if (gameWithOdds.textScore(true) == Constants.empty){
      return 0;
    }

    return 3;
  }





}


