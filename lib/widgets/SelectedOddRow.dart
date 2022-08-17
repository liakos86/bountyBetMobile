import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/Odd.dart';

class SelectedOddRow extends StatelessWidget{

  Odd odd;
  MatchEvent event;
  Function(Odd) callback;

  SelectedOddRow({
    required this.event,
    required this.odd,
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(4), // every row of list has margin of 4 across all directions
        height: 60, // every row of list has height 150
        child: Stack( // the row will be drawn as items on top of each other
          children: [

            Positioned(
                bottom:0,
                right: 0,
                left : 0,
                child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
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
                        Text(event.homeTeam + ' - ' + event.awayTeam,
                          style: TextStyle(fontSize: 15, color: Colors.black),),
                        Text(odd.betPredictionType.toString() + ' @ ' + odd.value,
                          style: TextStyle(fontSize: 18, color: Colors.green[700]),)
                      ],
                    ),

                  ],)
              ),
            ),

            Positioned(right : 0, child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.delete),
              onPressed: () => { callParent() },//callback.call(odd),
              backgroundColor: Colors.red[800],
            ),)


          ],
        )


    );
  }

  callParent() {
    callback.call(odd);
  }
}