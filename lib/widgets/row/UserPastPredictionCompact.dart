import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';

import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';

class UserPastPredictionCompact extends StatefulWidget {
  final UserPrediction prediction;

  const UserPastPredictionCompact({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  @override
  State<UserPastPredictionCompact> createState() => _UserPastPredictionCompactState();
}

class _UserPastPredictionCompactState extends State<UserPastPredictionCompact> {
  late UserPrediction prediction;

  @override
  void initState() {
    super.initState();
    prediction = widget.prediction;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: (prediction.betPredictionStatus) == BetPredictionStatus.WON ? Colors.green[200] : Colors.red[100],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child:

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Home Team Logo
            CircleAvatar(
              backgroundImage: NetworkImage(prediction.homeTeam.logo),
              radius: 14,
              backgroundColor: Colors.transparent,
            ),

            const SizedBox(width: 6),

            /// Home Team Name (right aligned)
            Expanded(
              flex: 3,
              child: Text(
                prediction.homeTeam.getLocalizedName(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            const SizedBox(width: 8),

            /// Score (centered)
            Text(
              "${scoreText(true)} - ${scoreText(false)}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(width: 8),

            /// Away Team Name (left aligned)
            Expanded(
              flex: 3,
              child: Text(
                prediction.awayTeam.getLocalizedName(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            const SizedBox(width: 6),

            /// Away Team Logo
            CircleAvatar(
              backgroundImage: NetworkImage(prediction.awayTeam.logo),
              radius: 14,
              backgroundColor: Colors.transparent,
            ),

            const Spacer(),

            /// Odd Value Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Text(
                prediction.betPredictionType!.text + prediction.value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        )


      ),
    );
  }




  Widget _buildResultIcon() {

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

    }

  
    String scoreText(bool isHome) {

  
      if (isHome)
        return prediction.homeScore.toString();
      else
        return prediction.awayScore.toString();
    }
  }

