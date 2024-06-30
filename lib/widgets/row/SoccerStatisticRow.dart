


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/enums/StatisticsNameType.dart';
import 'package:flutter_app/models/MatchEventStatisticSoccer.dart';
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
    padding: const EdgeInsets.all(4),
              child:

              Column(
              children:[

          Row(//top father

              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                      Align(alignment: Alignment.topLeft, child: Text(statistic.home)),
                      Align(alignment: Alignment.topCenter, child: Text( StatisticsNameType.getLocalizedString(context, statistic.name))),
                      Align(alignment: Alignment.topRight, child: Text(statistic.away)),

                ]
                ),


                Row(//top father

                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(flex: 1, child: SizedBox(
                        height: 20,
                        child: LinearProgressIndicator(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),

                          value: 25,
                          backgroundColor: Colors.red[100],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        ),
                      ),),
                      Expanded(flex: 1, child: SizedBox(
                        height: 20,
                        child: LinearProgressIndicator(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),

                          value: 25,
                          backgroundColor: Colors.red[100],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
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



}


