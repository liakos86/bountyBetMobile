import 'dart:async';

import 'package:flutter_app/models/MatchEventStatisticsWithIncidents.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/row/SoccerStatisticRow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/MatchEventStatisticSoccer.dart';
import 'package:flutter_app/models/constants/MatchIncidentsConstants.dart';
import 'package:flutter_app/models/MatchEventIncidentSoccer.dart';
import 'package:flutter_app/widgets/LogoWithTeamLarge.dart';

import '../models/match_event.dart';
import '../widgets/CustomTabIcon.dart';
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

class MatchInfoSoccerDetailsPageState extends State<MatchInfoSoccerDetailsPage> with SingleTickerProviderStateMixin{

  late MatchEvent event;

  late Function eventCallback;

  MatchEventIncidentSoccer injuriesStatistic = MatchEventIncidentSoccer.defIncident();

  List<MatchEventIncidentSoccer> incidents = <MatchEventIncidentSoccer>[];
  List<MatchEventStatisticSoccer> statistics = <MatchEventStatisticSoccer>[];

  GlobalKey middleKey = GlobalKey();

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    event = widget.event;
    eventCallback = widget.eventCallback;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    updateEvent();
    Timer.periodic(const Duration(seconds: 10), (timer) {

      updateEvent();

    });

  }

  @override
  Widget build(BuildContext context) {

    const int items = 2;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 16;
    double labelWidth = (width - (labelPadding * (items - 1))) / items;

    return

      Scaffold(
      appBar: AppBar(title: Text('${event.homeTeam.getLocalizedName()} - ${event.awayTeam.getLocalizedName()}', style: const TextStyle(fontSize: 16))),
    body:

    PageStorage(

    bucket: pageBucket,
    child:

      Column(

      children: [

        Expanded(flex:2,
            child:
                Container(
                  color:Colors.grey.shade50,
                child:
                Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child:
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LogoWithTeamLarge(team: event.homeTeam),
            MatchScoreMiddleText(key:middleKey, event: event, injuries: injuriesStatistic),
            LogoWithTeamLarge(team: event.awayTeam)
                    ],
        ))

        )),

        Expanded(flex:7, child:


        DefaultTabController(
          length: items,
          child: Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 1,
                backgroundColor: Colors.grey.shade50,
                bottom: TabBar(
                  indicator: const BoxDecoration(),
                  controller: _tabController,
                  labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),

                    tabs: [
                      CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.incidents, isSelected: _tabController.index == 0,),
                      CustomTabIcon(width: labelWidth, text: 'statistics', isSelected: _tabController.index == 1,),
                    ],

                    onTap: (index) {
                      setState(() {
                        _tabController.index = index;
                      });
                    }


                ),
              ),

              body: TabBarView(
                controller: _tabController,
                children: [

                  incidents.isEmpty? const Align(alignment: Alignment.center, child: Text('No incidents yet.') ) :

                  ListView.builder(
                      key: const PageStorageKey<String>(
                          'pageDetailsIncidents'),
                      itemCount: incidents.length,
                      itemBuilder: (context, item) {
                        return _buildIncidentRow(incidents[item]);
                      }),

                  statistics.isEmpty? const Align(alignment: Alignment.center, child: Text('No statistics yet.') ) :

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

    if (!mounted){
      return;
    }

    MatchEventStatisticsWithIncidents newIncidents = await HttpActionsClient.getStatisticsAsync(event.eventId);

    if(newIncidents.eventId == -1){
      return;
    }

    newIncidents.incidents.data.sort();
    var incomingIncidents = newIncidents.incidents.data;
    var incomingStats = newIncidents.statistics.data;

    MatchEventIncidentSoccer latestIncomingInjury = MatchEventIncidentSoccer.defIncident();

    for (MatchEventIncidentSoccer meis in incomingIncidents){
      print("ORDER " + meis.order.toString() + " ID : " + meis.id.toString());
      if (MatchIncidentsConstants.INJURY == meis.incident_type && meis.order > latestIncomingInjury.order){
        latestIncomingInjury = meis;
        continue;
      }

      if (MatchIncidentsConstants.PERIOD == meis.incident_type && meis.order > latestIncomingInjury.order){
        latestIncomingInjury = MatchEventIncidentSoccer.defIncident();
      }

      MatchEventIncidentSoccer existingIncident = incidents.firstWhere((element) => element.id == meis.id, orElse: () => MatchEventIncidentSoccer.defIncident());
      if (existingIncident.id == -1){
        incidents.add(meis);
      }else{
        existingIncident.copyFrom(meis);
      }

    }

    injuriesStatistic.copyFrom(latestIncomingInjury);

    for (MatchEventIncidentSoccer existing in List.of(incidents)){
      MatchEventIncidentSoccer incomingIncident = incomingIncidents.firstWhere((element) => element.id == existing.id, orElse: () => MatchEventIncidentSoccer.defIncident());
      if (incomingIncident.id == -1){
        incidents.remove(existing);
      }
    }

    for (MatchEventStatisticSoccer meis in incomingStats){
      if (meis.period == 'all' &&
          ( meis.name == "fouls" || meis.name == 'free_kicks' || meis.name ==  "passes" || meis.name == 'throw_ins'
       || meis.name == "expected_goals"  || meis.name =="corner_kicks"   || meis.name =="offsides"  || meis.name =='yellow_cards' || meis.name =="ball_possession")) {
        if (!statistics.contains(meis)) {
          // print('adding stat ' + meis.group);
          statistics.add(meis);
        } else {
          var firstWhere = statistics.firstWhere((element) =>
          element.id == meis.id);
          firstWhere.copyFrom(meis);
        }
      }


    }

    setState(() {
      incidents;
      statistics;
    });

  }

}