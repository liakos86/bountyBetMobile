// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/MatchEventStatus.dart';
// import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';
// import 'package:flutter_app/widgets/row/LiveMatchRow.dart';
//
// import '../../enums/WinnerType.dart';
// import '../../models/UserPrediction.dart';
// import '../../models/match_event.dart';
// import '../LogoWithName.dart';
//
//   class UpcomingOrEndedMatchRow extends StatefulWidget {
//
//     final List<UserPrediction> selectedOdds;
//
//     final MatchEvent gameWithOdds;
//
//     final Function(UserPrediction) callbackForOdds;
//
//     const UpcomingOrEndedMatchRow({Key ?key, required this.gameWithOdds, required this.callbackForOdds, required this.selectedOdds}) : super(key: key);
//
//     @override
//     UpcomingOrEndedMatchRowState createState() => UpcomingOrEndedMatchRowState(gameWithOdds: gameWithOdds, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
//   }
//
//   class UpcomingOrEndedMatchRowState extends State<UpcomingOrEndedMatchRow> {
//
//     UserPrediction? selectedPrediction;
//
//     List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//     Function(UserPrediction) callbackForOdds;
//
//     MatchEvent gameWithOdds;
//
//     UpcomingOrEndedMatchRowState({
//       required this.selectedOdds,
//       required this.gameWithOdds,
//       required this.callbackForOdds
//     });
//
//     @override
//     Widget build(BuildContext context) {
//       return
//
//         Wrap( //top parent
//             spacing: 0,
//
//             children: [
//
//               LiveMatchRow(gameWithOdds: gameWithOdds),
//
//               //ODDS ROW
//
//               if (gameWithOdds.odds != null
//                   && (MatchEventStatus.NOTSTARTED.statusStr ==  gameWithOdds.status))
//
//                 Container(color: Colors.white, child:
//                 Row(mainAxisSize: MainAxisSize.max,
//
//                   children: [
//                     Expanded(flex: 5,
//                         child: Padding(padding: const EdgeInsets.all(4),
//                             child: GestureDetectorForOdds(
//                               key: UniqueKey(),
//                               selectedOdds: selectedOdds,
//                               eventId: gameWithOdds.eventId,
//                               predictionText: '1:',
//                               callbackForOdds: callbackForOdds,
//                               prediction: gameWithOdds.odds?.odd1,
//                               toRemove: [
//                                 gameWithOdds.odds?.odd2,
//                                 gameWithOdds.odds?.oddX
//                               ],))),
//                     Expanded(flex: 4,
//                         child: Padding(padding: const EdgeInsets.all(4),
//                             child: GestureDetectorForOdds(
//                               key: UniqueKey(),
//                               selectedOdds: selectedOdds,
//                               eventId: gameWithOdds.eventId,
//                               predictionText: 'X:',
//                               callbackForOdds: callbackForOdds,
//                               prediction: gameWithOdds.odds?.oddX,
//                               toRemove: [
//                                 gameWithOdds.odds?.odd2,
//                                 gameWithOdds.odds?.odd1
//                               ],))),
//                     Expanded(flex: 5,
//                         child: Padding(padding: const EdgeInsets.all(4),
//                             child: GestureDetectorForOdds(
//                               key: UniqueKey(),
//                               selectedOdds: selectedOdds,
//                               eventId: gameWithOdds.eventId,
//                               predictionText: '2:',
//                               callbackForOdds: callbackForOdds,
//                               prediction: gameWithOdds.odds?.odd2,
//                               toRemove: [
//                                 gameWithOdds.odds?.odd1,
//                                 gameWithOdds.odds?.oddX
//                               ],)))
//                   ],
//                 )),
//
//             ]
//         );
//     }
//
//
//   }