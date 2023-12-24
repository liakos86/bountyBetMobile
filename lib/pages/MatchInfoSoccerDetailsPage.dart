import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/constants/MatchIncidentsConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';

import '../models/match_event.dart';
import '../widgets/MatchScoreMiddleText.dart';
import '../widgets/SoccerStatPeriodRow.dart';
import '../widgets/SoccerIncidentRow.dart';
import 'LivePage.dart';

class MatchInfoSoccerDetailsPage extends StatefulWidget{

  final MatchEvent event;

  final Function eventCallback;

  const MatchInfoSoccerDetailsPage({Key? key, required this.event, required this.eventCallback});


  @override
  MatchInfoSoccerDetailsPageState createState() => MatchInfoSoccerDetailsPageState();

}

class MatchInfoSoccerDetailsPageState extends State<MatchInfoSoccerDetailsPage>{

  late MatchEvent event;

  late Function eventCallback;

  GlobalKey middleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    event = widget.event;
    eventCallback = widget.eventCallback;

    Timer.periodic(const Duration(seconds: 10), (timer) {

      updateEvent();

    });

  }

  @override
  Widget build(BuildContext context) {

    return

      Scaffold(
      appBar: AppBar(title: Text('${event.homeTeam.name}  -  ${event.awayTeam.name}')),
    body:

    PageStorage(

    bucket: pageBucket,
    child:

      Column(

      children: [

        Expanded(flex:2,
            child:
                Container(
                  color:Colors.grey[100],
                child:
                Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LogoWithTeamLarge(team: event.homeTeam),
            MatchScoreMiddleText(key:middleKey, event: event),
            LogoWithTeamLarge(team: event.awayTeam)
                    ],
        ))

        )),

        Expanded(flex:7, child:


        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[500],
                  indicatorColor: Colors.black,
                  indicatorWeight: 2,

                  tabs: const [
                   Tab(text: 'Incidents'),
                   Tab(text: 'Statistics',),
                   Tab(text: 'TODO',),
                  ],
                ),
              ),

              body: TabBarView(
                children: [
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsIncidents'),
                      itemCount: event.incidents.length,
                      itemBuilder: (context, item) {
                        return _buildIncidentRow(event.incidents[item]);
                      }),
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsStats'),
                      itemCount: event.statistics.length,
                      itemBuilder: (context, item) {
                        return _buildStatRow(event.statistics[item]);
                      }),
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsNews'),
                      itemCount: event.statistics.length,
                      itemBuilder: (context, item) {
                        return _buildIncidentRow(event.incidents[item]);
                      })
                ],)

          ),
        )

        )

      ],

    )));

  }

  Widget _buildIncidentRow(MatchEventIncidentsSoccer stat) {
    if (MatchIncidentsConstants.PERIOD == stat.incident_type){
      return SoccerStatPeriodRow(key: UniqueKey(), statistic: stat);
    }

    return SoccerIncidentRow(key: UniqueKey(), incident: stat);
  }

  Widget _buildStatRow(MatchEventStatisticsSoccer stat) {


    return SizedBox(height: 10,);
  }

  void updateEvent() {

     MatchEvent newEvent = eventCallback.call();

      event.copyFrom(newEvent);



     middleKey.currentState?.setState(() {
       event;
     });
  }



}