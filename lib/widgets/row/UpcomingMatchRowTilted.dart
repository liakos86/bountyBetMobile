import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';

import '../../enums/WinnerType.dart';
import '../../helper/SharedPrefs.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/match_event.dart';
import '../../pages/ParentPage.dart';
import '../LogoWithName.dart';
import 'LiveMatchRowTilted.dart';

  class UpcomingOrEndedMatchRowTilted extends StatefulWidget {

    final List<UserPrediction> selectedOdds;

    final MatchEvent gameWithOdds;

    final Function(UserPrediction) callbackForOdds;

    const UpcomingOrEndedMatchRowTilted({Key ?key, required this.gameWithOdds, required this.callbackForOdds, required this.selectedOdds}) : super(key: key);

    @override
    UpcomingOrEndedMatchRowTiltedState createState() => UpcomingOrEndedMatchRowTiltedState(gameWithOdds: gameWithOdds, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

  class UpcomingOrEndedMatchRowTiltedState extends State<UpcomingOrEndedMatchRowTilted> {

    UserPrediction? selectedPrediction;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function(UserPrediction) callbackForOdds;

    MatchEvent gameWithOdds;

    UpcomingOrEndedMatchRowTiltedState({
      required this.selectedOdds,
      required this.gameWithOdds,
      required this.callbackForOdds
    });

    @override
    Widget build(BuildContext context) {
      return

        Stack(
            clipBehavior: Clip.none, // Allow positioning outside the container
            children: [

        Container(
          padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(bottom: 2, left: 12, right: 2),
      decoration: BoxDecoration(
      color: const Color(ColorConstants.my_dark_grey)
      , // Dark background color
      borderRadius: BorderRadius.circular(12),
      ),
      child:

        Wrap( //top parent
            spacing: 0,

            children: [

              LiveMatchRowTilted(gameWithOdds: gameWithOdds),

              //ODDS ROW

              if (gameWithOdds.odds != null
                  && (MatchEventStatus.NOTSTARTED.statusStr ==  gameWithOdds.status))
                //TODO: && match time not passed

               // Container(color: Colors.white, child:
                Row(mainAxisSize: MainAxisSize.max,

                  children: [
                    Expanded(flex: 5,
                        child: Padding(padding: const EdgeInsets.all(4),
                            child: GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: '1:',
                              callbackForOdds: callbackForOdds,
                              prediction: gameWithOdds.odds?.odd1,
                              toRemove: [
                                gameWithOdds.odds?.odd2,
                                gameWithOdds.odds?.oddX
                              ],))),
                    Expanded(flex: 4,
                        child: Padding(padding: const EdgeInsets.all(4),
                            child: GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: 'X:',
                              callbackForOdds: callbackForOdds,
                              prediction: gameWithOdds.odds?.oddX,
                              toRemove: [
                                gameWithOdds.odds?.odd2,
                                gameWithOdds.odds?.odd1
                              ],))),
                    Expanded(flex: 5,
                        child: Padding(padding: const EdgeInsets.all(4),
                            child: GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: '2:',
                              callbackForOdds: callbackForOdds,
                              prediction: gameWithOdds.odds?.odd2,
                              toRemove: [
                                gameWithOdds.odds?.odd1,
                                gameWithOdds.odds?.oddX
                              ],)))
                  ],
                )
      //),

            ]
        )
        ),

              Positioned(
                  top: 20, // Slightly above the container
                  left: 5, // Slightly left of the container
                  child:

                  _buildTiltedFavourite()


              ),

        ]//stack children
        );
    }

  _buildTiltedFavourite() {

   if ( MatchEventStatus.INPROGRESS.statusStr == gameWithOdds.status || MatchEventStatus.NOTSTARTED.statusStr == gameWithOdds.status ) {
     return
       Transform(
           transform: Matrix4.skewX(-0.2), // Tilt the container
           child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
               // margin: EdgeInsets.symmetric(horizontal: 4),
               decoration: BoxDecoration(
                 color: Colors.white,
                 // Background color of the parallelogram
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: Colors.black87, width: 1)
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
                           const Icon(Icons.star_outlined, color: Colors.red)
                               :
                           const Icon(Icons.star_border, color: Color(ColorConstants.my_dark_grey)),
                         )
                       ]
                   )
               )
           )
       );
   }else {
    return  const SizedBox();
   }
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


  }