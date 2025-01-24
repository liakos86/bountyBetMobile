import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/enums/WinnerType.dart';
import 'package:flutter_app/models/match_odds.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/widgets/DisplayOdd.dart';
import 'package:flutter_app/widgets/GestureDetectorForOdds.dart';

import '../../models/UserPrediction.dart';
import '../../models/constants/ColorConstants.dart';
import '../../models/match_event.dart';
import '../LogoWithName.dart';

class SelectedOddRow extends StatelessWidget {

  //final MatchEvent gameWithOdds;

  final UserPrediction prediction;

  final Function(UserPrediction)? callback;

  final BetPlacementStatus betPlacementStatus;


  SelectedOddRow({Key ?key,
    required this.prediction, required this.betPlacementStatus, required this.callback}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    MatchEvent gameWithOdds = ParentPageState.findEvent(prediction.eventId);

    return

      Stack(
          clipBehavior: Clip.none, // Allow positioning outside the container
          children: [

      Container(
      padding: const EdgeInsets.all(2),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
    color: const Color(ColorConstants.my_dark_grey)
    , // Dark background color
    borderRadius: BorderRadius.circular(12),
    ),
    child:

      Wrap(//top parent
          spacing: 0,

          children: [

                Row( //top father
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // OLA TA CHILDREN PREPEI NA GINOUN EXPANDED!!!!!!!!!!!!!!!
                      Expanded( //first column
                          flex: 10,
                          child:
                          Column(
                              children: [
                                Padding(padding: const EdgeInsets.only(left:12),
                                child:
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    LogoWithName(key: UniqueKey(),
                                      logoUrl: prediction.homeTeam.logo, name: prediction.homeTeam.getLocalizedName(), redCards: 0, logoSize: 18, fontSize: 10, winnerType: WinnerType.NONE,))
                                ),

                                Padding(padding: const EdgeInsets.only(left:12),
                                child:
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    LogoWithName(key: UniqueKey(),
                                      logoUrl: prediction.awayTeam.logo, name: prediction.awayTeam.getLocalizedName(), redCards: 0, logoSize: 18, fontSize: 10,  winnerType: WinnerType.NONE)
                                )),
                              ]
                          )),

                          Expanded(
                            flex:5,
                              child:

                              BetPredictionType.HOME_WIN.betPredictionCode == prediction.betPredictionType?.betPredictionCode ?
                              DisplayOdd(betPredictionType: BetPredictionType.HOME_WIN, prediction: prediction, odd: gameWithOdds.odds?.odd1)
                                  :
                              BetPredictionType.AWAY_WIN.betPredictionCode == prediction.betPredictionType?.betPredictionCode ?
                              DisplayOdd(betPredictionType: BetPredictionType.AWAY_WIN, prediction: prediction, odd: gameWithOdds.odds?.odd2)
                                  :
                              BetPredictionType.DRAW.betPredictionCode == prediction.betPredictionType?.betPredictionCode ?
                              DisplayOdd(betPredictionType: BetPredictionType.DRAW, prediction: prediction, odd: gameWithOdds.odds?.oddX)
                                  : const Text('-')
                          )
                          , // FIRST COLUMN END

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
                                      color: Colors.white),))
                              ]
                          )), //SECOND COLUMN END
                      //RD COLUMN END
                    ]
      // )
      ), //parent column end

          ]
      )

    ),

            if (betPlacementStatus != BetPlacementStatus.PLACED)

            Positioned(
                top: 10, // Slightly above the container
                right: -5, // Slightly left of the container
                child:

                _buildRemoveButton()


            ),



          ]);
  }


  _buildRemoveButton() {

      return
        RawMaterialButton(
          onPressed:  ()=> {callback?.call(prediction)},
          fillColor: Colors.red, // Background color
          shape: const CircleBorder(), // Ensures a circular button
          constraints: const BoxConstraints.tightFor(
            width: 30, // Custom smaller size
            height: 30,
          ),
          child: const Icon(
            Icons.close, // Icon for delete action
            size: 20, // Smaller icon size
            color: Colors.white, // Icon color
          ),
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