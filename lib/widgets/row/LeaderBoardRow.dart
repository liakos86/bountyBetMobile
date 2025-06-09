//
//
// import 'package:animated_background/animated_background.dart';
// import 'package:animated_background/particles.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_app/models/Standing.dart';
// import '../../models/League.dart';
// import '../../models/Season.dart';
// import '../../models/User.dart';
// import '../../models/constants/Constants.dart';
// import '../../models/LeagueWithData.dart';
// import '../../pages/LeagueStandingPage.dart';
// import '../../utils/cache/CustomCacheManager.dart';
//
// class LeaderBoardRow extends StatefulWidget {
//
//
//   final User user;
//
//   LeaderBoardRow({Key ?key, required this.user}) : super(key: key);
//
//   @override
//   LeaderBoardRowState createState() => LeaderBoardRowState(user: user);
// }
//
// class LeaderBoardRowState extends State<LeaderBoardRow> {
//
//   User user;
//
//   LeaderBoardRowState({
//     required this.user,
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
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
//                 const Expanded(//first column
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
//                             padding: EdgeInsets.all(4), child:
//
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               WidgetSpan(
//
//                                 child: Image(image: AssetImage("assets/images/1.png"),)
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
//       //), // FIRST COLUMN END
//
//                 Expanded(//first column
//                     flex: 14,
//                     child:
//
//                         Padding(
//                           padding: EdgeInsets.all(2),
//                           child:
//                     Column(
//
//                         children: [
//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.center,
//                           //   mainAxisSize: MainAxisSize.max,
//                           // children:[
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child:
//
//                             Text(user.username,
//                                 maxLines: 1,
//                                 softWrap: false,
//                                 style: const TextStyle(
//                                   //overflow: TextOverflow.ellipsis,
//                                     fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
//                           ),
//                          // ] ),
//
//                           Column(
//                               children:[
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child:
//                                   Text('Monthly balance ${user.balance.balance}' ,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black)),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child:
//                                   Text('Monthly form ${user.balance.monthlyWonBets} / ${user.balance.monthlyWonBets+user.balance.monthlyLostBets}' ,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black)),
//                                 ),
//                               ] )
//                         ]
//                     )
//                         )
//                 ),
//
//                 Expanded(flex: 3, child:
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child:
//                   Padding(
//                       padding: EdgeInsets.all(4), child:
//
//                   Text.rich(
//                     TextSpan(
//                       children: [
//                         WidgetSpan(
//
//
//                           child: CachedNetworkImage(
//                             cacheManager: CustomCacheManager(),
//                             imageUrl: 'https://xscore.cc/resb/team/asteras-tripolis.png',
//                             placeholder: (context, url) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                             errorWidget: (context, url, error) => Image.asset(Constants.assetNoLeagueImage, width: 32, height: 32,),
//                             height: 36,
//                             width: 36,
//                           )
//                         ),
//                         WidgetSpan(child: SizedBox(width: 16)),
//
//                       ],
//                     ),
//                   )
//
//                   ),
//                 ),)
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
