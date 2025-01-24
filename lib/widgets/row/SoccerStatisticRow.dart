


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/StatisticsNameType.dart';
import 'package:flutter_app/models/MatchEventStatisticSoccer.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SoccerStatisticRow extends StatefulWidget {

  final MatchEventStatisticSoccer statistic;


  SoccerStatisticRow({Key ?key, required this.statistic}) : super(key: key);

  @override
  SoccerStatisticRowState createState() => SoccerStatisticRowState(statistic: statistic);
}

class SoccerStatisticRowState extends State<SoccerStatisticRow> {

  MatchEventStatisticSoccer statistic;

  SoccerStatisticRowState({
    required this.statistic
  });


  @override
  Widget build(BuildContext context) {


    return

              Padding(
    padding: const EdgeInsets.all(6),
              child:

              Column(
              children:[

          Row(//top father

              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                      Align(alignment: Alignment.topLeft, child: Text(statistic.home, style: const TextStyle(color: Colors.white),)),
                      Align(alignment: Alignment.topCenter, child: Text( StatisticsNameType.getLocalizedString(context, statistic.name), style: const TextStyle(color: Colors.white),)),
                      Align(alignment: Alignment.topRight, child: Text(statistic.away, style: const TextStyle(color: Colors.white),)),

                ]
                ),


                Row(//top father

                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(flex: 1, child: SizedBox(
                        height: 20,
                        child:

                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0),
                          child:

                        LinearProgressIndicator(

                          borderRadius: const BorderRadius.all(Radius.circular(8)),

                          value: calcValueOf(statistic.home, statistic),
                          backgroundColor: Colors.red[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(ColorConstants.my_green)),
                        ),

                        )



                      ),),
                      Expanded(flex: 1, child: SizedBox(
                        height: 20,
                        child: LinearProgressIndicator(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),

                          value: calcValueOf(statistic.away, statistic),
                          backgroundColor: Colors.red[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(ColorConstants.my_green)),
                        ),
                      ),),

                    ]
                )

              ])
              // ]
              // )//parent column end
    //  )
    );
  }

  double calcValueOf(String valueStr, MatchEventStatisticSoccer statistic) {
    double finalValue = 0;
    if (statistic.group == 'shots' || statistic.name == 'offsides' || statistic.name == 'passes' ){
      int value = int.parse(valueStr);
      finalValue = value / (int.parse(statistic.home) + int.parse(statistic.away));
    }

    if (statistic.group == 'possession'){
      valueStr = valueStr.replaceAll('%', Constants.empty);
      int value = int.parse(valueStr);
      finalValue = value / (int.parse(statistic.home.replaceAll('%', Constants.empty)) + int.parse(statistic.away.replaceAll('%', Constants.empty)));
    }

    return finalValue;
  }



}


