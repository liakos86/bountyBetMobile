import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/Team.dart';
import '../models/UserPrediction.dart';
import '../models/constants/Constants.dart';
import 'LogoWithName.dart';
import 'RowWithTeams.dart';

class SelectedOddRow extends StatelessWidget{

  UserPrediction prediction;

  Function(UserPrediction) callback;

  SelectedOddRow({
    Key? key,
    required this.prediction,
    required this.callback
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DecoratedBox(

        decoration: BoxDecoration(color:  Colors.white,
         // borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border(

            bottom: BorderSide(width: 0.3, color: Colors.grey.shade600),
          ),
        ),

        child:

        // Padding(
        //     padding: EdgeInsets.all(4),
        //     child:
            Row(//top father
                mainAxisSize: MainAxisSize.max,
                children: [

                  Expanded(//first column
                      flex: 1,
                      child:
                            Align(
                              alignment: Alignment.center,
                              child:
                               Wrap(
                                  children:[
                                 Icon(
                                 Icons.sports_soccer_outlined,
                                 color: Colors.grey[800],
                               ),
                          ]
                      ))
                ),

                  Expanded(//first column
                      flex: 12,
                      child:
                      // child:
                      // Column(
                      //     children: [
                            // Row(
                            //   mainAxisSize: MainAxisSize.max,
                            // children: [


                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child:  //Text('fff')
                              //LogoWithName(key: UniqueKey(), logoUrl: prediction.homeTeam.logo, name: prediction.homeTeam.name)
                              RowWithTeams(key: UniqueKey(), homeTeam: prediction.homeTeam, awayTeam: prediction.awayTeam)
                            // ),

                            //
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child:
                            //
                            //   RowWithTeams(key: UniqueKey(), homeTeam: prediction.homeTeam, awayTeam: prediction.awayTeam)
                            //   // LogoWithName(key: UniqueKey(), logoUrl: prediction.awayTeam.logo, name: prediction.awayTeam.name)
                            // ),
                           // ]),

                          // Row(// third column
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: [
                          //       Padding(padding: EdgeInsets.all(6), child:
                          //       Text(textForPrediction(prediction), style: TextStyle(
                          //           fontSize: 14,
                          //           fontWeight:  FontWeight.w900,
                          //           color: Colors.green[800]),)),
                          //     ]
                          // ),
                          // ]
                      // )
                  ),

                  Expanded(
                flex: 2,
                child:
                IconButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(10),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
                  ),
                  onPressed: () {
                    callParent();
                  },
                  icon: Icon(Icons.remove_circle_outline),
                )

            // FloatingActionButton(
            //               mini: true,
            //               child: Icon(Icons.delete_forever_sharp),
            //               onPressed: () => { callParent() },//callback.call(odd),
            //               backgroundColor: Colors.white,
            //               foregroundColor: Colors.red[500],
            //             )
                    )

                ])//parent column end
    //    )
    );
  }

  callParent() {
    callback.call(prediction);
  }

  String textForPrediction(UserPrediction prediction) {
    String prefix = Constants.empty;


      if (prediction.betPredictionType == BetPredictionType.HOME_WIN) {
        prefix = prediction.homeTeam.name;
      } else if (prediction.betPredictionType == BetPredictionType.AWAY_WIN) {
        prefix = prediction.awayTeam.name;
      }else if (prediction.betPredictionType == BetPredictionType.DRAW) {
        prefix = "draw";
      }


    return '$prefix @ ${prediction.value}';
  }

}