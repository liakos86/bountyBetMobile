import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/UserPrediction.dart';
import '../models/UserBet.dart';
import 'SelectedOddRow.dart';

class UserBetRow extends StatelessWidget{

  UserBet bet;

  HashMap eventsPerIdMap;

  UserBetRow(this.bet, this.eventsPerIdMap);

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.all(4), // every row of list has margin of 4 across all directions
        height: 200,
        // every row of list has height 150
        child: Stack( // the row will be drawn as items on top of each other
          children: [

            Positioned(
                bottom:0,
                right: 0,
                left : 0,
                child: Container(
                    height: 100,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.transparent
                            ]
                        )
                    )
                )),
            Positioned(bottom : 0,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [

                    Icon(
                      Icons.sports_basketball,
                      color: Colors.deepOrangeAccent,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Possible earnings: ' + bet.toReturn().toStringAsFixed(2),
                          style: TextStyle(fontSize: 20, color: Colors.black),),

                        ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: bet.predictions.length,
                            itemBuilder: (context, item) {
                              return _buildSelectedOddRow(bet.predictions[item], eventsPerIdMap[bet.predictions[item].eventId]);
                            })
                      ],
                    ),

                  ],)
              ),
            ),
          ],
        )


    );
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd, MatchEvent event) {

    return SelectedOddRow(event: event, odd: bettingOdd, callback: (odd) => {});

  }


}