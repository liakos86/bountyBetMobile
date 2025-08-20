import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';

import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/context/AppContext.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';

class SelectedOddRow extends StatelessWidget {
  final UserPrediction prediction;
  final Function(UserPrediction)? callback;
  final BetPlacementStatus betPlacementStatus;

  const SelectedOddRow({
    Key? key,
    required this.prediction,
    required this.betPlacementStatus,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MatchEvent? gameWithOdds = AppContext.findEvent(prediction.eventId);

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            /// Teams Column
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoWithName(
                    key: UniqueKey(),
                    isHomeTeam: true,
                    goalScored: false,
                    logoUrl: prediction.homeTeam.logo,
                    name: prediction.homeTeam.getLocalizedName(),
                    redCards: 0,
                    logoSize: 18,
                    fontSize: 10,
                    winnerType: WinnerType.NONE,
                  ),
                  LogoWithName(
                    key: UniqueKey(),
                    isHomeTeam: false,
                    goalScored: false,
                    logoUrl: prediction.awayTeam.logo,
                    name: prediction.awayTeam.getLocalizedName(),
                    redCards: 0,
                    logoSize: 18,
                    fontSize: 10,
                    winnerType: WinnerType.NONE,
                  ),
                ],
              ),
            ),

            /// Selected Odd
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: _buildDisplayOdd(prediction, gameWithOdds),
              ),
            ),

            /// Match Time or Status
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  gameWithOdds.start_at_date_local +'\n\r' +gameWithOdds.start_at_local  ?? '',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            /// Remove Button
            if (betPlacementStatus != BetPlacementStatus.PLACED)
              Align(
                alignment: Alignment.topRight,
                child: _buildRemoveButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayOdd(UserPrediction prediction, MatchEvent? game) {
    final code = prediction.betPredictionType?.betPredictionCode;
    if (code == BetPredictionType.HOME_WIN.betPredictionCode) {
      return DisplayOdd(
        betPredictionType: BetPredictionType.HOME_WIN,
        prediction: prediction.betPredictionType!,
        odd: game?.odds?.odd1,
      );
    } else if (code == BetPredictionType.AWAY_WIN.betPredictionCode) {
      return DisplayOdd(
        betPredictionType: BetPredictionType.AWAY_WIN,
        prediction: prediction.betPredictionType!,
        odd: game?.odds?.odd2,
      );
    } else if (code == BetPredictionType.DRAW.betPredictionCode) {
      return DisplayOdd(
        betPredictionType: BetPredictionType.DRAW,
        prediction: prediction.betPredictionType!,
        odd: game?.odds?.oddX,
      );
    } else {
      return const Text('-', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildRemoveButton() {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.close, color: Colors.red, size: 20),
      onPressed: () => callback?.call(prediction),
    );
  }
}
