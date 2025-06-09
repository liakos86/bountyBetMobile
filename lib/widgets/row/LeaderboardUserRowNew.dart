import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/utils/BetUtils.dart';

import '../../models/User.dart';
import '../../models/UserBet.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../pages/OtherUserBetsPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class LeaderBoardUserFullInfoRow extends StatefulWidget {

  final User user;

  // final UserMonthlyBalance balance;

  // final String position;

  final bool isLeaderBoardWinner;

  final bool isCurrentLeaderBoard;

  const LeaderBoardUserFullInfoRow({Key ?key, required this.user, required this.isCurrentLeaderBoard, required this.isLeaderBoardWinner}) : super(key: key);

  @override
  LeaderBoardUserFullInfoRowState createState() => LeaderBoardUserFullInfoRowState(user: user, isCurrentLeaderBoard: isCurrentLeaderBoard, isLeaderBoardWinner: isLeaderBoardWinner );

}

  class LeaderBoardUserFullInfoRowState extends State<LeaderBoardUserFullInfoRow>{

    User user;

    bool isCurrentLeaderBoard;
    bool isLeaderBoardWinner;

    LeaderBoardUserFullInfoRowState({
      required this.user,
      required this.isCurrentLeaderBoard,
      required this.isLeaderBoardWinner,
    });

  @override
  Widget build(BuildContext context) {

    user.userBets.sort();

    return
       Stack(
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
                          user.username.length < 18 ? user.username : user.username.substring(0, 17),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        if (!isCurrentLeaderBoard)
                        const Spacer(),

                        if (!isCurrentLeaderBoard)
                        Text(
                        '${user.balance.position} ${AppLocalizations.of(context)!.out_of} ${user.balance.totalUsers}' ,
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
              _buildSmallStatBox(user.balance.betPredictionsMonthlyText(), AppLocalizations.of(context)!.month_preds),
              _buildSmallStatBox(user.balance.betPredictionsMonthlyPercentageText(), AppLocalizations.of(context)!.preds_perc),
              _buildSmallStatBox(user.balance.monthlyROIPercentageText(), AppLocalizations.of(context)!.month_roi),
              _buildSmallStatBox(user.balance.monthlyAmountROIText(), AppLocalizations.of(context)!.amount_returned),
            ],
          ),

          if (isCurrentLeaderBoard)
          const SizedBox(height: 8),

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
            left: -5, // Slightly left of the container
            child:

            _buildTiltedPosition(isCurrentLeaderBoard ? '${user.balance.position} ${AppLocalizations.of(context)!.out_of} ${user.balance.totalUsers}' : BetUtils.getLocalizedMonthString(context, user.balance.month, user.balance.year))


          ),

          if (AppContext.user.mongoUserId != Constants.defMongoId
              && AppContext.user.mongoUserId != user.mongoUserId && isCurrentLeaderBoard
          && isLeaderBoardWinner)
          Positioned(
              top: 0, // Slightly above the container
              right: 5, // Slightly left of the container
              child:

              _buildPredsButton()


          ),
        ],


    );
  }



  Widget _buildTiltedStatRow() {
    return

      Transform(
        transform: Matrix4.skewX(-0.1), // Tilt the container
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          // margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(ColorConstants.my_green), // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Row(
            children: [
              _buildTiltedStatBox(user.balance.betSlipsMonthlyText(), AppLocalizations.of(context)!.won_slips, 3, Colors.white),
              _buildTiltedStatBox(user.balance.betSlipsMonthlyPercentageText(), AppLocalizations.of(context)!.slips_percent, 2, Colors.white),
              _buildTiltedStatBox(user.balance.balanceLeaderBoard.toStringAsFixed(0), AppLocalizations.of(context)!.credits_with_sign, 2, Colors.amber),
            ],
          ),



        ),
      );
  }

  Widget _buildTiltedPosition(String text) {
    return

      Transform(
        transform: Matrix4.skewX(-0.1), // Tilt the container
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        // SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
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

  _buildPredsButton() {
    return
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.7),
              blurRadius: 40,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          key: UniqueKey(),
          onPressed: () {
            if (AppContext.user.mongoUserId == Constants.defMongoId ||
                AppContext.user.mongoUserId == user.mongoUserId) {
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserBetsPage(
                  key: UniqueKey(),
                  otherUser: user,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            minimumSize: const Size(0, 24),
          ),
          child: Text(
            '👀 ${AppLocalizations.of(context)!.view_predictions_text}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );

  }



}

