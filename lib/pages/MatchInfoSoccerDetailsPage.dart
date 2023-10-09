import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/MatchStatsConstants.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:flutter_app/widgets/LogoWithName.dart';

import '../models/match_event.dart';
import '../widgets/MatchScoreMiddleText.dart';
import '../widgets/SoccerStatPeriodRow.dart';
import '../widgets/SoccerStatisticsRow.dart';

class MatchInfoSoccerDetailsPage extends StatefulWidget{

  MatchEvent event;

  MatchInfoSoccerDetailsPage({required this.event});


  @override
  MatchInfoSoccerDetailsPageState createState() => MatchInfoSoccerDetailsPageState(event: event);

}

class MatchInfoSoccerDetailsPageState extends State<MatchInfoSoccerDetailsPage>{

  MatchEvent event;

  MatchInfoSoccerDetailsPageState({required this.event});

  @override
  Widget build(BuildContext context) {

    return

      Scaffold(
      appBar: AppBar(title: Text(event.homeTeam.name + '-' + event.awayTeam.name)),
    body:
      Column(

      children: [

        Expanded(flex:2,
            child:

                Container(
                  color:Colors.grey[100],
                child:

                Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12),
                  child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LogoWithTeamLarge(team: event.homeTeam),
            MatchScoreMiddleText(event: event),
            LogoWithTeamLarge(team: event.awayTeam)
                    ],
        ))

        )),

        Expanded(flex:7, child:


        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.grey[100],
                bottom: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.blue[500],
                  indicatorWeight: 3,

                  tabs: [
                   Tab(text: 'Statistics'),
                   Tab(text: 'Odds',),
                   Tab(text: 'News',),
                  ],
                ),
              ),

              body: TabBarView(
                children: [
                  ListView.builder(
                      itemCount: event.statistics.length,
                      itemBuilder: (context, item) {
                        return _buildRow(event.statistics[item]);
                      }),
                  ListView.builder(
                      itemCount: event.statistics.length,
                      itemBuilder: (context, item) {
                        return _buildRow(event.statistics[item]);
                      }),
                  ListView.builder(
                      itemCount: event.statistics.length,
                      itemBuilder: (context, item) {
                        return _buildRow(event.statistics[item]);
                      })
                ],)

          ),
        )

        )

      ],

    ));

  }

  Widget _buildRow(MatchEventsStatisticsSoccer stat) {
    if (MatchStatConstants.PERIOD == stat.incident_type){
      return SoccerStatPeriodRow(key: UniqueKey(), statistic: stat);
    }

    return SoccerStatisticsRow(key: UniqueKey(), statistic: stat);
  }



}