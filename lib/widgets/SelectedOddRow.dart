import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPredictionType.dart';
import 'package:flutter_app/models/match_event.dart';

import '../models/UserPrediction.dart';
import 'LogoWithName.dart';

class SelectedOddRow extends StatelessWidget{

  UserPrediction prediction;
  MatchEvent event;
  Function(UserPrediction) callback;

  SelectedOddRow({
    Key? key,
    required this.event,
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

        Padding(
            padding: EdgeInsets.all(4),
            child:
            Row(//top father
                mainAxisSize: MainAxisSize.max,
                children: [

                  Expanded(//first column
                      flex: 1,
                      child:
                      Column(
                          children: [
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
                      ))]
                  )),

                  Expanded(//first column
                      flex: 8,
                      child:
                      Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child:
                              LogoWithName(key: UniqueKey(), logoUrl: event.homeTeam.logo, name: event.homeTeam.name),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:
                              LogoWithName(key: UniqueKey(), logoUrl: event.awayTeam.logo, name: event.awayTeam.name),
                            )
                          ]
                      )),
                  //), // FIRST COLUMN END

                  Expanded(
                      flex: 6,
                      child:
                      Column(// third column
                          children: [
                            Padding(padding: EdgeInsets.all(6), child:
                            Text(textForPrediction(prediction), style: TextStyle(
                                fontSize: 14,
                                fontWeight:  FontWeight.w900,
                                color: Colors.green[800]),)),
                          ]
                      )),

            Expanded(
                flex: 2,
                child:
            FloatingActionButton(
                          mini: true,
                          child: Icon(Icons.delete_forever_sharp),
                          onPressed: () => { callParent() },//callback.call(odd),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red[500],
                        )
                    )
                ])//parent column end
        ));
  }

  callParent() {
    callback.call(prediction);
  }

  String textForPrediction(UserPrediction prediction) {
    String prefix = "Draw";
    if (prediction.betPredictionType == BetPredictionType.HOME_WIN){
        prefix = event.homeTeam.name;
    }else if (prediction.betPredictionType == BetPredictionType.AWAY_WIN){
        prefix = event.awayTeam.name;
    }

    return '$prefix ${prediction.value}';
  }

}