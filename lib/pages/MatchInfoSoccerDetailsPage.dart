import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/models/MatchEventStatisticsWithIncidents.dart';
import 'package:flutter_app/widgets/row/SoccerStatisticRow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventIncidentsSoccer.dart';
import 'package:flutter_app/models/MatchEventStatisticSoccer.dart';
import 'package:flutter_app/models/MatchEventStatisticsSoccer.dart';
import 'package:flutter_app/models/constants/MatchIncidentsConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';
import 'package:flutter_app/utils/MockUtils.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';
import 'package:http/http.dart';

import '../models/constants/UrlConstants.dart';
import '../models/match_event.dart';
import '../widgets/MatchScoreMiddleText.dart';
import '../widgets/row/SoccerStatPeriodRow.dart';
import '../widgets/row/SoccerIncidentRow.dart';
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

  List<MatchEventIncidentSoccer> incidents = <MatchEventIncidentSoccer>[];
  List<MatchEventStatisticSoccer> statistics = <MatchEventStatisticSoccer>[];

  GlobalKey middleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    event = widget.event;
    eventCallback = widget.eventCallback;

    updateEvent();
    Timer.periodic(const Duration(seconds: 10), (timer) {

      updateEvent();

    });

  }

  @override
  Widget build(BuildContext context) {

    return

      Scaffold(
      appBar: AppBar(title: Text('${event.homeTeam.getLocalizedName()}  -  ${event.awayTeam.getLocalizedName()}')),
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
          length: 2,
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

                  tabs:  [
                   Tab(text: AppLocalizations.of(context)!.incidents),
                   const Tab(text: 'Statistics',),
                  ],
                ),
              ),

              body: TabBarView(
                children: [
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsIncidents'),
                      itemCount: incidents.length,
                      itemBuilder: (context, item) {
                        return _buildIncidentRow(incidents[item]);
                      }),
                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsStats'),
                      itemCount: statistics.length,
                      itemBuilder: (context, item) {
                        return _buildStatRow(statistics[item]);
                      }),
                ],)

          ),
        )

        )

      ],

    )));

  }

  Widget _buildIncidentRow(MatchEventIncidentSoccer stat) {
    if (MatchIncidentsConstants.PERIOD == stat.incident_type){
      return SoccerStatPeriodRow(key: UniqueKey(), statistic: stat);
    }

    return SoccerIncidentRow(key: UniqueKey(), incident: stat);
  }

  Widget _buildStatRow(MatchEventStatisticSoccer stat) {

    return SoccerStatisticRow(key: UniqueKey(), statistic: stat);

  }

  void updateEvent() async{

    MatchEventStatisticsWithIncidents newIncidents = await getStatisticsAsync();
    if ( newIncidents.incidents.data.isNotEmpty){
      incidents.clear();
      incidents.addAll(newIncidents.incidents.data);
    }

    if ( newIncidents.statistics.data.isNotEmpty){
      statistics.clear();
      statistics.addAll(newIncidents.statistics.data);
    }


    if (!mounted){
      return;
    }

    setState(() {
      incidents;
      statistics;
    });

  }


  Future<MatchEventStatisticsWithIncidents> getStatisticsAsync() async{

    // return <MatchEventStatisticSoccer>[];

    String getStatsUrlFinal = UrlConstants.GET_EVENT_STATISTICS_URL + event.eventId.toString();
    try {
      Response response = await get(Uri.parse(getStatsUrlFinal)).timeout(const Duration(seconds: 3));
      var responseDec = await jsonDecode(response.body);
      return MatchEventStatisticsWithIncidents.fromJson(responseDec);
      // Iterable l = await json.decode(response.body);
      // List<MatchEventStatisticSoccer> incidents = List<MatchEventStatisticSoccer>.from(l.map((model)=> MatchEventStatisticSoccer.fromJson(model)));
      // return incidents;
    } catch (e) {
      print('STATS ERRROR ' + e.toString());
      return MatchEventStatisticsWithIncidents();
    }
  }



}