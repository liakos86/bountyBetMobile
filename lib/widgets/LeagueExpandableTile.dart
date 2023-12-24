import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/match_event.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/widgets/row/LiveMatchRow.dart';

import '../enums/MatchEventStatus.dart';
import '../models/UserPrediction.dart';
import '../models/league.dart';
import 'UpcomingMatchRow.dart';

class LeagueExpandableTile extends StatefulWidget {

  League league;

  List<MatchEvent> events;

  List<UserPrediction> selectedOdds = <UserPrediction>[];

  Function(UserPrediction) callbackForOdds;

 // Function ?callbackForEvents;

  LeagueExpandableTile(
      {Key ?key, required this.league, required this.events, required this.selectedOdds, required this.callbackForOdds})
      : super(key: key);

  @override
  LeagueExpandableTileState createState() =>
      LeagueExpandableTileState();
  }

  class LeagueExpandableTileState extends State<LeagueExpandableTile>{

    late League league;

    late List<MatchEvent> events;

    List<UserPrediction> selectedOdds = <UserPrediction>[];

    late Function(UserPrediction) callbackForOdds;

    //LeagueExpandableTileState({required this.league, required this.events, required this.selectedOdds, required this.callbackForOdds});

    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      league = widget.league;
      events = widget.events;
      selectedOdds = widget.selectedOdds;
      callbackForOdds = widget.callbackForOdds;

      return Theme(
        key: UniqueKey(),
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,
          ),
        ),


           // child: GestureDetector(

                child: ExpansionTile(
                    key: UniqueKey(),
                    maintainState: false,
                    iconColor: Colors.transparent,
                    collapsedIconColor: Colors.transparent,
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.yellow[50],
                    subtitle: Text(league.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
                    trailing: Text('(${events.length})', style: const TextStyle(color: Colors.black, fontSize: 10),),
                    leading: Image.network(
                      league.logo ?? "https://tipsscore.com/resb/no-league.png",
                      height: 24,
                      width: 24,
                    ),
                    title: Text(league.section.name.toUpperCase(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    children: events.map((item)=> _buildSelectedOddRow(item)).toList()
                ),

         //   )
      );

      //       child: ExpansionTile(
      //           key: UniqueKey(),
      //           maintainState: false,
      //           iconColor: Colors.transparent,
      //           collapsedIconColor: Colors.transparent,
      //           initiallyExpanded: true,
      //           collapsedBackgroundColor: Colors.white,
      //           backgroundColor: Colors.yellow[50],
      //           subtitle: Text(league.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
      //           trailing: Text('(${events.length})', style: const TextStyle(color: Colors.black, fontSize: 10),),
      //           leading: Image.network(
      //             league.logo ?? "https://tipsscore.com/resb/no-league.png",
      //             height: 24,
      //             width: 24,
      //           ),
      //           title: Text(league.section!.name.toUpperCase(),
      //               style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
      //           children: events.map((item)=> _buildSelectedOddRow(item)).toList()
      //       )
      // );



    return ExpansionTile(
      maintainState: true,
      iconColor: Colors.transparent,
      collapsedIconColor: Colors.transparent,
      initiallyExpanded: false,
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.yellow[50],
      subtitle: Text(league.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
      trailing: Text('(${events.length})', style: const TextStyle(color: Colors.black, fontSize: 10),),
      leading: Image.network(
        league.logo ?? "https://tipsscore.com/resb/no-league.png",
        height: 24,
        width: 24,
      ),
      title: Text(league.section!.name.toUpperCase(),
          style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
      children: events.map((item)=> _buildSelectedOddRow(item)).toList()
    );
  }

  Widget _buildSelectedOddRow(MatchEvent event) {
    MatchEventStatus? matchEventStatus =  MatchEventStatus.fromStatusText(event.status);
    if (matchEventStatus == MatchEventStatus.INPROGRESS || matchEventStatus == MatchEventStatus.FINISHED
        || matchEventStatus == MatchEventStatus.POSTPONED || matchEventStatus == MatchEventStatus.CANCELLED) {
      return LiveMatchRow(key: UniqueKey(), gameWithOdds: event, isFavourite: sharedPrefs.favEventIds.contains(event.eventId.toString()));
    }

    return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
  }

}