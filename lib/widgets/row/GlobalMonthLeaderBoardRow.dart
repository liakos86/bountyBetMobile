// import 'package:flutter/material.dart';
//
// import '../../models/User.dart';
// import '../../models/UserBet.dart';
// import '../../models/UserPrediction.dart';
// import '../../models/context/AppContext.dart';
// import 'UserPastPredictionCompact.dart';
//
//
//
// class GlobalMonthLeaderboardRow extends StatefulWidget {
//   final User user;
//   final int position;
//
//
//   const GlobalMonthLeaderboardRow({Key? key, required this.user,
//     required this.position}) : super(key: key);
//
//   @override
//   State<GlobalMonthLeaderboardRow> createState() => _GlobalMonthLeaderboardRowState();
// }
//
// class _GlobalMonthLeaderboardRowState extends State<GlobalMonthLeaderboardRow> {
//   late User _user;
//   late int position;
//   UserPrediction? lastPrediction;
//
//   @override
//   void initState() {
//     super.initState();
//     _user = widget.user;
//     position = widget.position;
//   }
//
//   @override
//   void didUpdateWidget(covariant GlobalMonthLeaderboardRow oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.user != widget.user || oldWidget.position != widget.position) {
//       setState(() {
//         _user = widget.user;
//         position = widget.position;
//         // _fb = _user.fantasyBalance;
//       });
//     }
//   }
//
//   Widget _buildAnimatedDeltaIcon(int delta) {
//     // print('delta is ' + delta.toString());
//     Icon icon;
//     if (delta > 0) {
//       icon = const Icon(Icons.arrow_upward, color: Colors.green, size: 16);
//     } else if (delta < 0) {
//       icon = const Icon(Icons.arrow_downward, color: Colors.red, size: 16);
//     } else {
//       icon = const Icon(Icons.remove, color: Colors.grey, size: 16);
//     }
//
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 3000),
//       transitionBuilder: (child, animation) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0.0, 0.5),
//             end: Offset.zero,
//           ).animate(animation),
//           child: FadeTransition(opacity: animation, child: child),
//         );
//       },// Must be a unique Key to trigger animation
//       //key: ValueKey<int>(delta),
//       child: Container(
//         key: ValueKey<int>(delta), // Important: this triggers the switch
//         child: icon,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserBet? lastBet = _user.userBets.isNotEmpty ? _user.userBets[0] : null;
//
//     // MatchEvent? lastEvent;
//     if (lastBet != null && lastBet.predictions.isNotEmpty) {
//       lastBet.predictions.sort(UserPrediction.compareByValueDescending);
//       lastPrediction = lastBet.predictions[0];
//       // lastEvent = lastPrediction!.event; // Make sure this is correctly set from your model
//     }
//
//     return Card(
//       color: AppContext.user.mongoUserId == _user.mongoUserId ? Colors.blue[50] : Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             /// Main user row
//             Row(
//               children: [
//                 // Rank and movement
//                 Column(
//                   children: [
//                     Text(
//                       '#$position',
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 4),
//                     _buildAnimatedDeltaIcon(_user.positionDelta),
//                   ],
//                 ),
//                 const SizedBox(width: 16),
//
//                 // Username and balance
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(_user.username,
//                           maxLines: 1,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                       Text('ROI ' + _user.currentMonthRoi.toStringAsFixed(2) + '%',
//                           maxLines: 1,
//                           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
//                     ],
//                   ),
//                 ),
//
//                 // Stats (wins/losses)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text('✅ Bets: ${_user.overallWonBets}',
//                         style: const TextStyle(fontSize: 12)),
//                     Text('✅ Bet amount:: ${_user.betAmountOverallReturned}',
//                         style: const TextStyle(fontSize: 12)),
//                     Text('❌ Bet amount: ${_user.betAmountOverall}',
//                         style: const TextStyle(fontSize: 12)),
//                   ],
//                 ),
//               ],
//             ),
//
//             /// Spacer
//             if (lastPrediction != null ) const SizedBox(height: 6),
//
//             /// UserPredictionCardCompact
//             if (lastPrediction != null )
//               UserPastPredictionCompact(
//                 prediction: lastPrediction!,
//                 // event: lastEvent,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }
