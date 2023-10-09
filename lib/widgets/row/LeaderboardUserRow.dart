
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/UserLevel.dart';
import 'package:flutter_app/models/StandingRow.dart';

import '../../models/User.dart';

class LeaderboardUserRow extends StatefulWidget {

  User user;


  LeaderboardUserRow({Key ?key, required this.user}) : super(key: key);

  @override
  LeaderboardRowState createState() => LeaderboardRowState(user: user);
}

class LeaderboardRowState extends State<LeaderboardUserRow> {

  User user;

  LeaderboardRowState({
    required this.user
  });



  @override
  Widget build(BuildContext context) {


    return

      Padding(
        padding: const EdgeInsets.all(6),
        child:

      Row(//top father
          mainAxisSize: MainAxisSize.max,
          children: [

            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  user.userLevel.levelIcon,
                  style: TextStyle(fontFamily: 'MaterialIcons'),
                ),
              ),
            ),

            Expanded(
              flex: 10,
                child:
                Column(
                    children: [

                      Row(

                          children:[
                            Padding(padding: EdgeInsets.all(6), child:
                            Text(user.username, style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),))
                          ]),

                      Row(

                      children:[
                      Padding(padding: const EdgeInsets.all(6), child:
                      Text( ('BetSlips Won Month: ${user.monthlyWonBets}/${user.monthlyWonBets+user.monthlyLostBets} '
                          'Overall: ${user.overallWonBets}/${user.overallWonBets+user.overallLostBets}'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),))
                    ]),


                      Row(

                          children:[
                            Padding(padding: EdgeInsets.all(6), child:
                            Text( ('Predictions Won Month: ${user.monthlyWonPredictions}/${user.monthlyWonPredictions+user.monthlyLostPredictions} '
                                'Overall: ${user.overallWonPredictions}/${user.overallWonPredictions+user.overallLostPredictions}'),
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),))
                          ])


                    ]
                )),

            Expanded(
                flex: 5,

                child:

                    // Container(
                    //   color: Colors.red,
                    //   child:

                Column(
                  mainAxisSize: MainAxisSize.max,
                  children:[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children :[

                        Expanded(
                            // color: Colors.grey,
                            child:

                        Align(
                        alignment: Alignment.center,
                        child:

                        Padding(padding: const EdgeInsets.all(4),

                        child:

                        Text(
                            user.balance.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                                )
                        )
                        )
                        )
                        )
                      ]
                    ),

                    Row(
                        children :[

                          Expanded(
                              // color: Colors.red,
                              child:

                          Align(
                            alignment: Alignment.center,
                            child:

                          // SizedBox(
                          //   width: 100,
                          //   height: 30,
                          //   child:
                          FloatingActionButton.extended(

                              icon: const Icon(Icons.navigation),
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              onPressed: () => {},
                            label: const Text('bounty'),
                          )
                        //  )
                          )
                          )
                        ]
                    )
                  ]
                )
                  //  )
            ),
          ])
      );
  }
}


