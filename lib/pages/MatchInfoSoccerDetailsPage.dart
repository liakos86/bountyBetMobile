import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/matchEventStatisticsSoccer.dart';
import 'package:flutter_app/widgets/LiveMatchRow.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:flutter_app/widgets/LogoWithTeamName.dart';

import '../models/match_event.dart';
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
      appBar: AppBar(title: Text('Match info')),
    body:
      Column(

      children: [

        Expanded(flex:2,
            child:

        Row(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

         Align(alignment: Alignment.center, child:
          LogoWithTeamLarge(team: event.homeTeam),
          ),

          // Align(alignment: Alignment.center, child:
          Text('0-0', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),),
            // ,),

          // Align(alignment: Alignment.centerRight, child:
          LogoWithTeamLarge(team: event.awayTeam)
        // ,)


        ],)

        ),


        Expanded(flex:7, child:


        DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: TabBar(
                  labelColor: Colors.white,

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



        // ListView.builder(
        // itemCount: event.statistics.length,
        //     itemBuilder: (context, item) {
        //       return _buildRow(event.statistics[item]);
        //     })

        )

      ],

    ));

  }

  Widget _buildRow(MatchEventsStatisticsSoccer stat) {
    return SoccerStatisticsRow(key: UniqueKey(), statistic: stat);
    // return LiveMatchRow(key: UniqueKey(), gameWithOdds: event,);
  }

}