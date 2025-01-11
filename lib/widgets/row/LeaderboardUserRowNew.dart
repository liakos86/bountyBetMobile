import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';

import '../../models/User.dart';


class LeaderBoardUserFullInfoRow extends StatefulWidget {

  final User user;

  LeaderBoardUserFullInfoRow({Key ?key, required this.user}) : super(key: key);

  @override
  LeaderBoardUserFullInfoRowState createState() => LeaderBoardUserFullInfoRowState(user: user);
}

  class LeaderBoardUserFullInfoRowState extends State<LeaderBoardUserFullInfoRow>{


    User user;

    LeaderBoardUserFullInfoRowState({
      required this.user,
    });

  @override
  Widget build(BuildContext context) {



    return Stack(
        clipBehavior: Clip.none, // Allow positioning outside the container
        children: [

    // return
    Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Image
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://xscore.cc/resb/team/asteras-tripolis.png',
                ),
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
                          user.username.length < 14 ? user.username : '${user.username.substring(0, 12)}..',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.flag, color: Colors.blue, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Greece',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                _buildTiltedStatRow(),


                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 12),


          // Additional Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStatBox(user.betPredictionsMonthlyText(), 'Month\nPreds'),
              _buildSmallStatBox(user.betPredictionsMonthlyPercentageText(), 'Pred\n%'),
              _buildSmallStatBox('6.20', 'High\nOdds'),
              _buildSmallStatBox('60%', 'Last10\nTips'),
              _buildSmallStatBox('58%', 'Last100\nTips'),
            ],
          ),
          SizedBox(height: 16),

          // Last 5 Tips Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Align icons to the center

            children: [
              _buildTipIcon(Icons.check, Colors.white, const Color(ColorConstants.my_green)),
              _buildTipIcon(Icons.check, Colors.white, const Color(ColorConstants.my_green)),
              _buildTipIcon(Icons.check, Colors.white, const Color(ColorConstants.my_green)),
              _buildTipIcon(Icons.check, Colors.white, const Color(ColorConstants.my_green)),
              _buildTipIcon(Icons.close, Colors.white, Colors.red),
            ],
          ),
        ],
      ),
    ),

          // Small Green Box at Top-Left Corner
          Positioned(
            top: 10, // Slightly above the container
            left: 0, // Slightly left of the container
            child:

            _buildTiltedPosition(user.userPosition.toString())


          ),
        ],
    );
  }






  Widget _buildTiltedStatRow() {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(ColorConstants.my_green), // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Row(
            children: [
              _buildTiltedStatBox(user.betSlipsMonthlyText(), 'Won Slips', 3),
              _buildTiltedStatBox(user.betSlipsMonthlyPercentageText(), '', 2),
              _buildTiltedStatBox(user.balance.toStringAsFixed(0), 'Credits', 2),
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
            color: const Color(ColorConstants.my_green), // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)

        ),
      );
  }

  Widget _buildTiltedStatBox(String value, String label, int flex) {
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
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (label.isNotEmpty )
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
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

  Widget _buildTipIcon(IconData icon, Color color, Color backGr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backGr,// Color(0xFF2C2C2E), // Background color for circular icon
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }



}

