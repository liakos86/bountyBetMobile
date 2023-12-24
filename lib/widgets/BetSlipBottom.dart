//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/utils/BetUtils.dart';
//
// import '../enums/ChangeEvent.dart';
// import '../enums/MatchEventStatus.dart';
// import '../enums/MatchEventStatusMore.dart';
// import '../utils/MockUtils.dart';
// import '../models/UserPrediction.dart';
// import '../models/match_event.dart';
// import 'SelectedOddRow.dart';
//
// class BetSlipBottom extends StatefulWidget {
//
//   //bool showOdds = false;
//
//   List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//   /*
//    * Input
//    */
//   Function(UserPrediction) callbackForBetRemoval = (toRemove)=>{};
//
//   Function(double) callbackForBetPlacement = (amount)=>{};
//
//   BetSlipBottom({Key? key, required this.selectedOdds, required this.callbackForBetPlacement, required this.callbackForBetRemoval}) : super (key: key);
//
//   @override
//   BetSlipBottomState createState() => BetSlipBottomState(callbackForBetPlacement: callbackForBetPlacement, callbackForBetRemoval: callbackForBetRemoval, selectedOdds: selectedOdds);
//
// }
//
// class BetSlipBottomState extends State<BetSlipBottom>{
//
//   TextEditingController betAmountController = TextEditingController();
//
//   /*
//    * Input
//    */
//   Function(double) callbackForBetPlacement = (amount)=>{};
//
//   /*
//    * Input
//    */
//   Function(UserPrediction) callbackForBetRemoval = (toRemove)=>{};
//
//   //bool showOdds = false;
//
//   List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//   double bettingAmount = 0;
//
//   BetSlipBottomState({
//     required this.selectedOdds,
//     required this.callbackForBetPlacement,
//     required this.callbackForBetRemoval,
//    // required this.showOdds
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//
//       Scaffold(
//           backgroundColor: Colors.grey[200],
//           body:
//           Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children : [
//                 Expanded( flex:9 , child: ListView.builder(
//                     padding: const EdgeInsets.all(8),
//                     itemCount: selectedOdds.length,
//                     itemBuilder: (context, item) {
//                       return _buildBettingOddRow(selectedOdds[item]);
//                     })
//                 ),
//
//                 Expanded( flex:1 ,
//                     child:
//                         Container(
//                             height: double.infinity,
//                             width: double.infinity,
//                            decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
//                 child:
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Expanded(flex: 5, child: Align(alignment: Alignment.centerLeft, child: Text('Return: ' + (bettingAmount * BetUtils.finalOddOf(selectedOdds)).toStringAsFixed(2)))),
//                         Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2)))),
//                         Expanded(
//                           flex: 3,
//                           child: TextField(
//                             controller: betAmountController,
//                             onChanged:
//                                 (text) {
//                               setState(() {
//                                 try{
//                                   double.parse(text);
//                                 }catch(e){
//                                   bettingAmount = 0;
//                                   return;
//                                 }
//
//                                 bettingAmount = double.parse(text);
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'Amount',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))
//                 ),
//
//                 Expanded( flex:1 ,
//                   child:
//                   TextButton(
//                     style: ButtonStyle(
//                         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                         backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
//                     ),
//                     onPressed: () {
//                       if (bettingAmount <= 0){
//                         return;
//                       }
//
//                       Navigator.pop(context);
//                       callbackForBetPlacement.call(bettingAmount);
//                     },
//                     child: Text('Place Bet'),
//                   ),
//                 )
//               ]
//           ) ) ;
//   }
//
//   Widget _buildBettingOddRow(UserPrediction bettingOdd) {
//     //MatchEvent eventOfOdd = ParentPageState.findEvent(bettingOdd.eventId);
//       MatchEvent eventOfOdd = MockUtils().mockEvent(
//           100,
//           1.5,
//           1.5,
//           1.5,
//           1.5,
//           1.5,
//           MatchEventStatus.INPROGRESS.statusStr,
//           MatchEventStatusMore.INPROGRESS_1ST_HALF.statusStr,
//           ChangeEvent.NONE);
//
//     return SelectedOddRow(key: UniqueKey(), event: eventOfOdd, prediction: bettingOdd, callback: (odd) =>
//         removePrediction(odd)
//     );
//   }
//
//   removePrediction(UserPrediction bettingOdd){
//     callbackForBetRemoval.call(bettingOdd);
//
//     setState(() {
//       selectedOdds.remove(bettingOdd);
//     });
//
//   }
//
//
// }
//
