import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';
import '../SoccerIncidentBox.dart';

class SoccerStatPeriodRow extends StatelessWidget {

  final MatchEventIncidentSoccer statistic;

  SoccerStatPeriodRow({Key ?key, required this.statistic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 20,

          decoration: BoxDecoration(color:  Colors.grey[200],
              border: const Border(top: BorderSide(color: Colors.black, width: 0.5), bottom: BorderSide(color: Colors.black, width: 0.5))),
          child:
              Padding(
                padding: const EdgeInsets.all(4),
                child:
                Row(//top father
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(statistic.text! , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                    ]
                ),
      ));
  }
}
