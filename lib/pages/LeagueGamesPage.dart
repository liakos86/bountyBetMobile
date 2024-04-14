// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/helper/SharedPrefs.dart';
// import 'package:flutter_app/pages/ParentPage.dart';
// import '../enums/MatchEventStatus.dart';
// import '../models/UserPrediction.dart';
// import '../models/league.dart';
// import '../models/match_event.dart';
// import '../widgets/row/LiveMatchRow.dart';
// import '../widgets/UpcomingMatchRow.dart';
//
//
// class LeagueGamesPage extends StatefulWidget{
//
//   @override
//   LeagueGamesPageState createState() => LeagueGamesPageState(league, selectedOdds, callbackForOdds);
//
//   final League league;
//
//   final List<UserPrediction> selectedOdds;
//
//   final List<String> favourites;
//
//   final Function(UserPrediction) callbackForOdds;
//
//   LeagueGamesPage({required this.league, required this.selectedOdds, required this.callbackForOdds, required this.favourites});
//
// }
//
// class LeagueGamesPageState extends State<LeagueGamesPage>{
//
//   League league = League.defLeague();
//
//   late List<String> favourites;
//
//   List<UserPrediction> selectedOdds = <UserPrediction>[];
//
//   Function(UserPrediction) callbackForOdds = (a) => {};
//
//   LeagueGamesPageState(_league, _selectedOdds, _callbackForOdds) {
//     this.league = _league;
//     this.selectedOdds = _selectedOdds;
//     this.callbackForOdds = _callbackForOdds;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     favourites = widget.favourites;
//
//     return
//       Scaffold(
//         appBar: AppBar(title: Text(league.name)),
//     body:
//     ExpansionTile(
//         key: UniqueKey(),
//         maintainState: false,
//         iconColor: Colors.transparent,
//         collapsedIconColor: Colors.transparent,
//         initiallyExpanded: true,
//         collapsedBackgroundColor: Colors.white,
//         backgroundColor: Colors.yellow[50],
//         subtitle: Text(league.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
//         trailing: Text('(${league.events.length})', style: const TextStyle(color: Colors.black, fontSize: 10),),
//         leading: Image.network(
//           league.logo ?? "https://tipsscore.com/resb/no-league.png",
//           height: 24,
//           width: 24,
//         ),
//         title: Text(league.section!.name.toUpperCase(),
//             style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
//         children: league.events.map((item)=> _buildSelectedOddRow(item)).toList()
//     )
//       );
//   }
//
//   Widget _buildSelectedOddRow(MatchEvent event) {
//     MatchEventStatus? matchEventStatus =  MatchEventStatus.fromStatusText(event.status);
//     if (matchEventStatus == MatchEventStatus.INPROGRESS || matchEventStatus == MatchEventStatus.FINISHED
//         || matchEventStatus == MatchEventStatus.POSTPONED || matchEventStatus == MatchEventStatus.CANCELLED) {
//       return LiveMatchRow(key: UniqueKey(), gameWithOdds: event);
//     }
//
//     return UpcomingMatchRow(key: UniqueKey(), gameWithOdds: event, selectedOdds: selectedOdds, callbackForOdds: callbackForOdds);
//   }
//
// }