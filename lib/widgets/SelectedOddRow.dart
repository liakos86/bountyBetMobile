import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../models/UserPrediction.dart';
import '../models/match_event.dart';
import 'LogoWithName.dart';

class SelectedOddRow extends StatelessWidget {

  //final MatchEvent gameWithOdds;

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;


  SelectedOddRow({Key ?key,
    //required this.gameWithOdds,
    required this.prediction, required this.callback}) : super(key: key);

  // @override
  // SelectedOddRowState createState() => SelectedOddRowState(//gameWithOdds: gameWithOdds,
  //     prediction: prediction, callback: callback);

// }

// class SelectedOddRowState extends State<SelectedOddRow> {
//
//   UserPrediction prediction;
//
//   Function(UserPrediction)? callback;
//
//   // MatchEvent gameWithOdds;
//
//   SelectedOddRowState({
//     required this.prediction,
//     // required this.gameWithOdds,
//     required this.callback
//   });

  @override
  Widget build(BuildContext context) {

    MatchEvent gameWithOdds = ParentPageState.findEvent(prediction.eventId);

    return

      Wrap(//top parent
          spacing: 0,

          children: [

            DecoratedBox(//first child
                decoration: BoxDecoration(color: Colors.white ,
                  //  borderRadius: BorderRadius.only(topLeft:  Radius.circular(2), topRight:  Radius.circular(2)),
                  border: Border(
                    top: BorderSide(width: 0.3, color: Colors.grey.shade600),
                    left: BorderSide(width: 0, color: Colors.transparent),
                    right: BorderSide(width: 0, color: Colors.transparent),
                    bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
                  ), ),
                child:
                Row( //top father
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                      Expanded( //first column
                          flex: 10,
                          child:
                          Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    LogoWithName(key: UniqueKey(),
                                      logoUrl: prediction.homeTeam.logo, name: prediction.homeTeam.getLocalizedName(), redCards: 0, logoSize: 18, fontSize: 10,)),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    LogoWithName(key: UniqueKey(),
                                      logoUrl: prediction.awayTeam.logo, name: prediction.awayTeam.getLocalizedName(), redCards: 0, logoSize: 18, fontSize: 10,)),
                              ]
                          )), // FIRST COLUMN END

                      Expanded(
                          flex: 6,

                          child:
                          Column( //second column
                              children: [
                                Align(alignment: Alignment.center, child:
                                Text(
                                  (gameWithOdds.start_at_local),

                                  style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),))
                              ]
                          )), //SECOND COLUMN END
                      //RD COLUMN END
                    ])), //parent column end

            //ODDS ROW
              Container(color: Colors.white, child:
              Row(mainAxisSize: MainAxisSize.max,
                children: [
                  //1
                  Expanded(flex: 5,
                      child: DisplayOdd(betPredictionType: BetPredictionType.HOME_WIN, prediction: prediction, odd: gameWithOdds.odds?.odd1)
                  ),

                  //X
                  Expanded(flex: 5,
                      child: DisplayOdd(betPredictionType: BetPredictionType.DRAW, prediction: prediction, odd: gameWithOdds.odds?.oddX)
                  ),

                  //2
                  Expanded(flex: 5,
                      child: DisplayOdd(betPredictionType: BetPredictionType.AWAY_WIN, prediction: prediction, odd: gameWithOdds.odds?.odd2)
                  ),
                ],
              )),
          ]
      );
  }

}













// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/enums/BetPredictionType.dart';
// import 'package:flutter_app/models/match_event.dart';
//
// import '../models/Team.dart';
// import '../models/UserPrediction.dart';
// import '../models/constants/Constants.dart';
// import 'LogoWithName.dart';
// import 'RowWithTeams.dart';
//
// class SelectedOddRow extends StatelessWidget{
//
//   UserPrediction prediction;
//
//   Function(UserPrediction) callback;
//
//   SelectedOddRow({
//     Key? key,
//     required this.prediction,
//     required this.callback
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//
//         decoration: BoxDecoration(color:  Colors.white,
//          // borderRadius: BorderRadius.all(Radius.circular(10)),
//           border: Border(
//
//             bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
//           ),
//         ),
//
//         child:
//
//         // Padding(
//         //     padding: EdgeInsets.all(4),
//         //     child:
//             Row(//top father
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//
//                   Expanded(//first column
//                       flex: 1,
//                       child:
//                             Align(
//                               alignment: Alignment.center,
//                               child:
//                                Wrap(
//                                   children:[
//                                  Icon(
//                                  Icons.sports_soccer_outlined,
//                                  color: Colors.grey[800],
//                                ),
//                           ]
//                       ))
//                 ),
//
//                   Expanded(//first column
//                       flex: 12,
//                       child:
//                       // child:
//                       // Column(
//                       //     children: [
//                             // Row(
//                             //   mainAxisSize: MainAxisSize.max,
//                             // children: [
//
//
//                             // Align(
//                             //   alignment: Alignment.centerLeft,
//                             //   child:  //Text('fff')
//                               //LogoWithName(key: UniqueKey(), logoUrl: prediction.homeTeam.logo, name: prediction.homeTeam.name)
//                               RowWithTeams(key: UniqueKey(), homeTeam: prediction.homeTeam, awayTeam: prediction.awayTeam)
//                             // ),
//
//                             //
//                             // Align(
//                             //   alignment: Alignment.centerRight,
//                             //   child:
//                             //
//                             //   RowWithTeams(key: UniqueKey(), homeTeam: prediction.homeTeam, awayTeam: prediction.awayTeam)
//                             //   // LogoWithName(key: UniqueKey(), logoUrl: prediction.awayTeam.logo, name: prediction.awayTeam.name)
//                             // ),
//                            // ]),
//
//                           // Row(// third column
//                           //     mainAxisSize: MainAxisSize.max,
//                           //     children: [
//                           //       Padding(padding: EdgeInsets.all(6), child:
//                           //       Text(textForPrediction(prediction), style: TextStyle(
//                           //           fontSize: 14,
//                           //           fontWeight:  FontWeight.w900,
//                           //           color: Colors.green[800]),)),
//                           //     ]
//                           // ),
//                           // ]
//                       // )
//                   ),
//
//                   Expanded(
//                 flex: 2,
//                 child:
//                 IconButton(
//                   style: ButtonStyle(
//                       elevation: MaterialStateProperty.all<double>(10),
//                       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
//                       backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
//                   ),
//                   onPressed: () {
//                     callParent();
//                   },
//                   icon: Icon(Icons.remove_circle_outline),
//                 )
//
//             // FloatingActionButton(
//             //               mini: true,
//             //               child: Icon(Icons.delete_forever_sharp),
//             //               onPressed: () => { callParent() },//callback.call(odd),
//             //               backgroundColor: Colors.white,
//             //               foregroundColor: Colors.red[500],
//             //             )
//                     )
//
//                 ])//parent column end
//     //    )
//     );
//   }
//
//   callParent() {
//     callback.call(prediction);
//   }
//
//   String textForPrediction(UserPrediction prediction) {
//     String prefix = Constants.empty;
//
//
//       if (prediction.betPredictionType == BetPredictionType.HOME_WIN) {
//         prefix = prediction.homeTeam.getLocalizedName();
//       } else if (prediction.betPredictionType == BetPredictionType.AWAY_WIN) {
//         prefix = prediction.awayTeam.getLocalizedName();
//       }else if (prediction.betPredictionType == BetPredictionType.DRAW) {
//         prefix = "draw";
//       }
//
//
//     return '$prefix @ ${prediction.value}';
//   }
//
// }