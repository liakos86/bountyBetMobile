import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/utils/BetUtils.dart';

import '../../models/User.dart';
import '../../models/UserBet.dart';
import '../../models/UserMonthlyBalance.dart';


class LeaderBoardUserFullInfoRow extends StatefulWidget {

  final User user;

  // final UserMonthlyBalance balance;

  // final String position;

  final bool isCurrentLeaderBoard;

  const LeaderBoardUserFullInfoRow({Key ?key, required this.user, required this.isCurrentLeaderBoard}) : super(key: key);

  @override
  LeaderBoardUserFullInfoRowState createState() => LeaderBoardUserFullInfoRowState(user: user, isCurrentLeaderBoard: isCurrentLeaderBoard);

}

  class LeaderBoardUserFullInfoRowState extends State<LeaderBoardUserFullInfoRow>{

    User user;

    // String position;

    bool isCurrentLeaderBoard;

    // UserMonthlyBalance balance;

    LeaderBoardUserFullInfoRowState({
      required this.user,
      required this.isCurrentLeaderBoard,
      // required this.balance
    });

  @override
  Widget build(BuildContext context) {

    user.userBets.sort();

    return Stack(
        clipBehavior: Clip.none, // Allow positioning outside the container
        children: [

    // return
    Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),

      decoration: BoxDecoration(
        color: const Color(ColorConstants.my_dark_grey)
        , // Dark background color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Profile Picture and Main Info
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
          margin: const EdgeInsets.only(top: 8),
          child:
          const Align(alignment: Alignment.bottomCenter,
            child:
              // User Image
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://xscore.cc/resb/league/europe-uefa-champions-league.png',
                ),
              )
          )
          ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and Flag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.username.length < 25 ? user.username : '${user.username.substring(0, 22)}..',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                      ],
                    ),
                 //   SizedBox(height: 8),

                _buildTiltedStatRow(),


                  ],
                ),
              ),

            ],
          ),
          const SizedBox(height: 12),


          // Additional Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStatBox(user.balance.betPredictionsMonthlyText(), 'Month\nPreds'),
              _buildSmallStatBox(user.balance.betPredictionsMonthlyPercentageText(), 'Pred\n%'),
              _buildSmallStatBox(user.balance.monthlyROIPercentageText(), 'Month\nROI'),
              _buildSmallStatBox(user.balance.monthlyAmountROIText(), 'Bet\nReturned'),
            ],
          ),

          if (isCurrentLeaderBoard)
          const SizedBox(height: 16),

          // Last 5 Tips Section
          if (isCurrentLeaderBoard)
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Align icons to the center

            children: [

              user.userBets.isNotEmpty ?
              _buildTipIcon(Colors.white, user.userBets[0])
              :
                 _buildTipIcon(Colors.white, null),

              if (user.userBets.length > 1)
              _buildTipIcon(Colors.white, user.userBets[1])
              else
                _buildTipIcon(Colors.white, null),

              if (user.userBets.length > 2)
              _buildTipIcon(Colors.white, user.userBets[2])
              else
              _buildTipIcon(Colors.white, null),

              if (user.userBets.length > 3)
              _buildTipIcon(Colors.white, user.userBets[3])
              else
              _buildTipIcon(Colors.white, null),

              if (user.userBets.length > 4)
              _buildTipIcon(Colors.white, user.userBets[4])
              else
              _buildTipIcon(Colors.white, null),
            ],
          ),
        ],
      ),
    ),

          // Small Green Box at Top-Left Corner
          Positioned(
            top: -5, // Slightly above the container
            left: 0, // Slightly left of the container
            child:

            _buildTiltedPosition(isCurrentLeaderBoard ? user.userPosition.toString() : BetUtils.getLocalizedMonthString(context, user.balance.month, user.balance.year))


          ),
        ],
    );
  }






  Widget _buildTiltedStatRow() {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(ColorConstants.my_green), // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Row(
            children: [
              _buildTiltedStatBox(user.balance.betSlipsMonthlyText(), 'Won Slips', 3, Colors.white),
              _buildTiltedStatBox(user.balance.betSlipsMonthlyPercentageText(), 'Slips %', 2, Colors.white),
              _buildTiltedStatBox(user.balance.balanceLeaderBoard.toStringAsFixed(0), '\$ Credits', 2, Colors.amber),
            ],
          ),



        ),
      );
  }

  Widget _buildTiltedPosition(String text) {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          // margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.red, // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)

        ),
      );
  }

  Widget _buildTiltedStatBox(String value, String label, int flex, Color color) {
    return
      Expanded(flex: flex,

        child:

        Column(

          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (label.isNotEmpty )
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      // ),
    // )
    );
  }


  Widget _buildStatBox(String value, String label) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatBox(String value, String label) {
    return Expanded(
      flex: 1,
    child: Column(
    // return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        // SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ));
  }

  Widget _buildTipIcon(Color color, UserBet? bet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bet == null || bet.betStatus == BetStatus.WITHDRAWN ? Colors.blue.shade200 : bet.betStatus == BetStatus.WON ? const Color(ColorConstants.my_green) : Colors.red,// Color(0xFF2C2C2E), // Background color for circular icon
        ),
        child: Icon(bet == null || bet.betStatus == BetStatus.WITHDRAWN ? Icons.question_mark : bet.betStatus == BetStatus.WON ? Icons.check :  Icons.close , color: color, size: 18),
      ),
    );
  }



}

