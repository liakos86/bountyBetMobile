import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/FantasyLeagueStatus.dart';
import '../../helper/SharedPrefs.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';
import 'LiveMatchRowTilted.dart';

  class MatchRowTilted extends StatefulWidget {

    final List<UserPrediction> selectedOdds;

    final MatchEvent gameWithOdds;

    final Function(UserPrediction) callbackForOdds;

    final Function(UserPrediction) callbackForWalkThrough;

    const MatchRowTilted({Key ?key, required this.gameWithOdds, required this.callbackForOdds, required this.callbackForWalkThrough, required this.selectedOdds}) : super(key: key);

    @override
    MatchRowTiltedState createState() => MatchRowTiltedState(gameWithOdds: gameWithOdds, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds, callbackForWalkThrough: callbackForWalkThrough);
  }

  class MatchRowTiltedState extends State<MatchRowTilted> {

    UserPrediction? selectedPrediction;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    Function(UserPrediction) callbackForOdds;

    Function(UserPrediction) callbackForWalkThrough;

    MatchEvent gameWithOdds;

    MatchRowTiltedState({
      required this.selectedOdds,
      required this.gameWithOdds,
      required this.callbackForOdds,
      required this.callbackForWalkThrough
    });

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        clipBehavior: Clip.antiAlias, // Ensures children are clipped to the shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8), // Must match the Card
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // Apply same radius
              border: const Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                /// Match row (title/info)
                LiveMatchRowTilted(gameWithOdds: gameWithOdds,),

                /// Odds row
                if (gameWithOdds.odds != null &&
                    gameWithOdds.status == MatchEventStatus.NOTSTARTED.statusStr
                    &&
                    (
                        (AppContext.fantasyLeague.mongoId == Constants.defMongoId && hasNotSeenWalkThrough())
                        ||
                        (AppContext.fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode &&
                         AppContext.fantasyLeague.selectedLeagueIds.contains(gameWithOdds.leagueId)
                        )
                    )
                    // AppContext.fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode &&
                    // AppContext.fantasyLeague.selectedLeagueIds.contains(gameWithOdds.leagueId)
                )

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child:



                            GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: '1:',
                              callbackForOdds: (AppContext.fantasyLeague.mongoId == Constants.defMongoId && hasNotSeenWalkThrough()) ? callbackForWalkThrough : callbackForOdds,
                              prediction: gameWithOdds.odds?.odd1,
                              toRemove: [
                                gameWithOdds.odds?.odd2,
                                gameWithOdds.odds?.oddX
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: 'X:',
                              callbackForOdds: (AppContext.fantasyLeague.mongoId == Constants.defMongoId && hasNotSeenWalkThrough()) ? callbackForWalkThrough : callbackForOdds,
                              prediction: gameWithOdds.odds?.oddX,
                              toRemove: [
                                gameWithOdds.odds?.odd2,
                                gameWithOdds.odds?.odd1
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: GestureDetectorForOdds(
                              key: UniqueKey(),
                              selectedOdds: selectedOdds,
                              eventId: gameWithOdds.eventId,
                              predictionText: '2:',
                              callbackForOdds: (AppContext.fantasyLeague.mongoId == Constants.defMongoId && hasNotSeenWalkThrough()) ? callbackForWalkThrough : callbackForOdds,
                              prediction: gameWithOdds.odds?.odd2,
                              toRemove: [
                                gameWithOdds.odds?.odd1,
                                gameWithOdds.odds?.oddX
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

  bool hasNotSeenWalkThrough(){
    return !sharedPrefs.getBoolByKey(sp_seen_walk_through);
  }



  // _buildTiltedFavourite() {
  //
  //  if ( MatchEventStatus.INPROGRESS.statusStr == gameWithOdds.status || MatchEventStatus.NOTSTARTED.statusStr == gameWithOdds.status ) {
  //    return
  //      Transform(
  //          transform: Matrix4.skewX(-0.2), // Tilt the container
  //          child: Container(
  //              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //              // margin: EdgeInsets.symmetric(horizontal: 4),
  //              decoration: BoxDecoration(
  //                color: Colors.white,
  //                // Background color of the parallelogram
  //                borderRadius: BorderRadius.circular(8),
  //                border: Border.all(color: Colors.black87, width: 1)
  //              ),
  //              child:
  //
  //
  //              GestureDetector(
  //                  onTap: () async =>
  //                  {
  //
  //                    if ((await checkFirebasePermission())
  //                        .authorizationStatus ==
  //                        AuthorizationStatus.authorized){
  //
  //                      if (gameWithOdds.isFavourite){
  //                        sharedPrefs.removeFavEvent(
  //                            gameWithOdds.eventId.toString()),
  //                        updateFav(false)
  //                      } else
  //                        {
  //                          sharedPrefs.appendEventId(
  //                              gameWithOdds.eventId.toString()),
  //                          updateFav(true)
  //                        },
  //                      ParentPageState.favouritesUpdate(),
  //                    }
  //                  },
  //
  //                  child:
  //                  Column(
  //                      children: [
  //                        Align(
  //                          alignment: Alignment.center,
  //                          child:
  //                          gameWithOdds.isFavourite ?
  //                          const Icon(Icons.star_outlined, color: Colors.redAccent)
  //                              :
  //                          const Icon(Icons.star_border, color: Color(ColorConstants.my_dark_grey)),
  //                        )
  //                      ]
  //                  )
  //              )
  //          )
  //      );
  //  }else {
  //   return  const SizedBox();
  //  }
  // }

    // Future<NotificationSettings> checkFirebasePermission() async {
    //   FirebaseMessaging messaging = FirebaseMessaging.instance;
    //   return await messaging.requestPermission(
    //     alert: true,
    //     announcement: false,
    //     badge: true,
    //     carPlay: false,
    //     criticalAlert: false,
    //     provisional: false,
    //     sound: true,
    //   );
    // }
    //
    // updateFav(bool newfav) {
    //   setState(() {
    //     gameWithOdds.isFavourite = newfav;
    //   });
    // }


  }