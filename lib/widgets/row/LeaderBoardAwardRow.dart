

import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Standing.dart';
import 'package:flutter_app/models/UserAward.dart';
import '../../models/League.dart';
import '../../models/Season.dart';
import '../../models/User.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/constants/Constants.dart';
import '../../models/LeagueWithData.dart';
import '../../pages/LeagueStandingPage.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/User.dart';


class LeaderBoardAwardRow extends StatefulWidget {

  final UserAward award;

  final String username;

  LeaderBoardAwardRow({Key ?key, required this.award, required this.username}) : super(key: key);

  @override
  LeaderBoardAwardRowState createState() => LeaderBoardAwardRowState(award: award, username: username);
}

class LeaderBoardAwardRowState extends State<LeaderBoardAwardRow>{


  UserAward award;

  String username;

  LeaderBoardAwardRowState({
    required this.award,
    required this.username
  });

  @override
  Widget build(BuildContext context) {

    var awardMonth = award.awardMonth;
    var awardYear = award.awardYear;



    return Stack(
      clipBehavior: Clip.none, // Allow positioning outside the container
      children: [

        // return
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(ColorConstants.my_dark_grey)
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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://xscore.cc/resb/team/asteras-tripolis.png',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username and Flag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(

                              username.length > 12 ? '${username.substring(0, 12)}...' : username
                              ,


                              style: TextStyle(

                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
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
                  _buildSmallStatBox('18%', 'ROI\nYield'),
                  _buildSmallStatBox('2.08', 'Avg\nOdds'),
                  _buildSmallStatBox('6.20', 'High\nOdds'),
                  _buildSmallStatBox('60%', 'Last10\nTips'),
                  _buildSmallStatBox('58%', 'Last100\nTips'),
                ],
              ),
              // SizedBox(height: 16),
              //
              // // Last 5 Tips Section
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center, // Align icons to the center
              //
              //   children: [
              //     _buildTipIcon(Icons.check, Colors.black54, Colors.greenAccent),
              //     _buildTipIcon(Icons.check, Colors.black54, Colors.greenAccent),
              //     _buildTipIcon(Icons.check, Colors.black54, Colors.greenAccent),
              //     _buildTipIcon(Icons.check, Colors.black54, Colors.greenAccent),
              //     _buildTipIcon(Icons.stop, Colors.white, Colors.red),
              //   ],
              // ),
            ],
          ),
        ),

        // Small Green Box at Top-Left Corner
        Positioned(
            top: 10, // Slightly above the container
            left: 0, // Slightly left of the container
            child:

            _buildTiltedPosition('$awardMonth/$awardYear')


        ),
      ],
    );
  }






  Widget _buildTiltedStatRow() {
    return

      Transform(
        transform: Matrix4.skewX(-0.2), // Tilt the container
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Color(ColorConstants.my_green), // Background color of the parallelogram
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          Row(
            children: [
              _buildTiltedStatBox(award.winningBalance.toString(), 'Balance', 3),
              _buildTiltedStatBox('56%', '', 2),
              _buildTiltedStatBox('1.862', 'Tendex', 2),
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
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            // margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Color(ColorConstants.my_green), // Background color of the parallelogram
              borderRadius: BorderRadius.circular(8),
            ),
            child:

            Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),)

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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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









//
//
//
// class LeaderBoardAwardRow extends StatefulWidget {
//
//
//   final UserAward award;
//
//   final String username;
//
//   LeaderBoardAwardRow({Key ?key, required this.award, required this.username}) : super(key: key);
//
//   @override
//   LeaderBoardAwardRowState createState() => LeaderBoardAwardRowState(award: award, username: username);
// }
//
// class LeaderBoardAwardRowState extends State<LeaderBoardAwardRow> {
//
//   UserAward award;
//
//   String username;
//
//   LeaderBoardAwardRowState({
//     required this.award,
//     required this.username
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     var awardMonth = award.awardMonth;
//     var awardYear = award.awardYear;
//
//     return
//
//       GestureDetector(
//         onTap: () {
//
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Text('what?')),
//           );
//
//     },
//     child:
//
//        SizedBox(
//          height: 76,
//     child:
//           Row(//top father
//
//               //mainAxisSize: MainAxisSize.max,
//               children: [
//                 // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
//                  Expanded(//first column
//                     flex: 2,
//                     child:
//
//                     // Column(
//                     //
//                     // children: [
//                         Align(
//                         alignment: Alignment.centerLeft,
//                         child:
//                         Padding(
//                             padding: const EdgeInsets.all(4), child:
//
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               WidgetSpan(
//
//                                 child: Text( '$awardMonth/$awardYear', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
//                                   // child: CachedNetworkImage(
//                                   //   imageUrl: user.username ?? '',
//                                   //   placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                                   //   errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                                   //   height: 32,
//                                   //   width: 32,
//                                   // )
//                               ),
//                               WidgetSpan(child: SizedBox(width: 16)),
//
//                             ],
//                           ),
//                         )
//
//                         ),
//                         ),
//
//                     // ]
//                 // )
//        ),
//
//                 Expanded(//first column
//                   flex: 2,
//                   child:
//
//                   // Column(
//                   //
//                   // children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child:
//                     Padding(
//                         padding: const EdgeInsets.all(4), child:
//
//                     Text.rich(
//                       TextSpan(
//                         children: [
//                           WidgetSpan(
//
//                               child: Text( '$username with ${award.winningBalance}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
//                             // child: CachedNetworkImage(
//                             //   imageUrl: user.username ?? '',
//                             //   placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                             //   errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                             //   height: 32,
//                             //   width: 32,
//                             // )
//                           ),
//                           WidgetSpan(child: SizedBox(width: 16)),
//
//                         ],
//                       ),
//                     )
//
//                     ),
//                   ),
//
//                   // ]
//                   // )
//                 ),
//       //), // FIRST COLUMN END
//
//               ]
//           )
//       )
//       );
//       // )
//       // );
//   }
//
// }
//
//
