import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'SoccerStatisticBox.dart';

class SoccerStatPeriodRow extends StatelessWidget {

  final MatchEventsStatisticsSoccer statistic;

  SoccerStatPeriodRow({Key ?key, required this.statistic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 50,

          decoration: BoxDecoration(color:  Colors.grey[200],
              border: Border(top: BorderSide(color: Colors.black, width: 0.5), bottom: BorderSide(color: Colors.black, width: 0.5))),
          child:
              Padding(
                padding: EdgeInsets.all(4),
                child:
                Row(//top father
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(statistic.text! , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                    ]
                ),
      ));
  }
}
