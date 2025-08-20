import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';
import 'package:flutter_app/widgets/LogoWithName.dart';

import '../../enums/ChangeEvent.dart';
import '../../enums/MatchEventStatus.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';
import '../../utils/BetUtils.dart';

class UserPredictionCardTilted extends StatefulWidget {
  final UserPrediction prediction;
  final MatchEvent event;
  final Function(UserPrediction)? callback;

  const UserPredictionCardTilted({
    Key? key,
    required this.prediction,
    required this.callback,
    required this.event,
  }) : super(key: key);

  @override
  State<UserPredictionCardTilted> createState() => _UserPredictionCardTiltedState();
}

class _UserPredictionCardTiltedState extends State<UserPredictionCardTilted> {
  late UserPrediction prediction;
  late Function(UserPrediction)? callback;
  late MatchEvent event;

  @override
  void initState() {
    super.initState();
    prediction = widget.prediction;
    callback = widget.callback;
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {

    bool finishedWithOdds = (event != null && event?.odds != null && event?.winnerCodeNormalTime != null &&
        MatchEventStatus.FINISHED == MatchEventStatus.fromStatusText(event!.status));

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: const Border(
              bottom: BorderSide(color: Colors.white, width: 0.5),
            ),
          ),
          //padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(//second column
                  flex: finishedWithOdds ? 3 : 0
                  ,
                  child:

              finishedWithOdds ?
              SizedBox(height:60, child:
              BetUtils.buildWinnerOdds(event?.odds, event?.winnerCodeNormalTime)
              ) : SizedBox()),

              /// Team Logos and Names
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LogoWithName(
                      goalScored: false,
                      isHomeTeam: true,
                      logoUrl: prediction.homeTeam.logo,
                      logoSize: 20,
                      fontSize: 12,
                      name: prediction.homeTeam.getLocalizedName(),
                      redCards: 0,
                      winnerType: WinnerType.NONE,
                    ),
                    LogoWithName(
                      goalScored: false,
                      isHomeTeam: false,
                      logoUrl: prediction.awayTeam.logo,
                      logoSize: 20,
                      fontSize: 12,
                      name: prediction.awayTeam.getLocalizedName(),
                      redCards: 0,
                      winnerType: WinnerType.NONE,
                    ),
                  ],
                ),
              ),

              /// Match Status
              Expanded(
                flex: 3,
                child: event.eventId != -1
                    ? Text(
                  event!.display_status,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                )
                    : const SizedBox.shrink(),
              ),


              /// Result Icon or Delete
              Expanded(
                flex: 2,
                child: _buildResultIcon(),
              ),

              /// Odds
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.center,
                  child: DisplayOdd(
                    betPredictionType: prediction.betPredictionType!,
                    prediction: prediction.betPredictionType!,
                    odd: prediction,
                  ),
                ),
              ),

              /// Scores (if available)
              (prediction.homeScore != null) ?
                Expanded(
                    flex: flexSizeForTrailing(),

                    child:

                    // (MatchEventStatus.fromStatusText(gameWithOdds.status) == MatchEventStatus.INPROGRESS) ?

                    Column(// third column
                        children: [
                          Padding(padding: const EdgeInsets.all(6), child:

                          Text(scoreText(true), style: TextStyle(
                              fontSize: event.changeEvent == ChangeEvent.HOME_GOAL ? 13 : 12,
                              fontWeight:  FontWeight.w900,
                              color: event.changeEvent == ChangeEvent.HOME_GOAL ? Colors.redAccent : Colors.black87),)),

                          Padding(padding: const EdgeInsets.all(6), child:
                          Text(scoreText(false), style: TextStyle(
                              fontSize: event.changeEvent == ChangeEvent.AWAY_GOAL ? 13 : 12,
                              fontWeight: FontWeight.w900,
                              color: event.changeEvent == ChangeEvent.AWAY_GOAL ? Colors.redAccent : Colors.black87),)),
                        ]
                    )

                  // : Container()

                ) : const SizedBox(width:8),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    if (callback == null) {
      Color iconColor;
      IconData iconData;

      switch (prediction.betPredictionStatus) {
        case BetPredictionStatus.WON:
          iconColor = const Color(ColorConstants.my_green);
          iconData = Icons.check;
          break;
        case BetPredictionStatus.LOST:
          iconColor = Colors.red;
          iconData = Icons.close;
          break;
        case BetPredictionStatus.PENDING:
          iconColor = Colors.blueAccent;
          iconData = Icons.downloading_rounded;
          break;
        default:
          iconColor = Colors.grey;
          iconData = Icons.pause;
          break;
      }

      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: iconColor,
        ),
        child: Icon(iconData, color: Colors.white, size: 18),
      );
    } else {
      return IconButton(
        onPressed: () => callback!.call(prediction),
        icon: const Icon(Icons.delete, color: Colors.red),
      );
    }
  }  flexSizeForTrailing() {
    if (event.textScore(true) == Constants.empty && prediction.homeScore == null){
      return 0;
    }

    return 3;
  }

  String scoreText(bool isHome) {
    if (-1 != event.eventId) {
      return event.textScore(isHome);
    }

    if (isHome)
      return prediction.homeScore.toString();
    else
      return prediction.awayScore.toString();
  }
}
