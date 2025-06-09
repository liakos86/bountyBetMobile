// You have to add this manually, for some reason it cannot be added automatically
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/MatchEventStatus.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/LeagueWithData.dart';
import '../models/constants/ColorConstants.dart';
import '../widgets/LeagueExpandableTile.dart';
import '../widgets/row/DialogProgressBarWithText.dart';

final pageBucket = PageStorageBucket();

class LivePage extends StatefulWidget{//}WithName {

  @override
  LivePageState createState() => LivePageState();

  final List<LeagueWithData> allLeagues;

  LivePage({
    Key? key,
    required this.allLeagues,
  } ) : super(key: key);

}

class LivePageState extends State<LivePage> with WidgetsBindingObserver{

  late List<LeagueWithData> allLeagues;// = AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY].where((element) => element.liveEvents.isNotEmpty);// <LeagueWithData>[];

  List<String> favourites = <String>[];

  List<LeagueWithData> leaguesWd = <LeagueWithData>[];

  @override
  void initState(){
    allLeagues = widget.allLeagues;
    favourites = getFavourites();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    if (allLeagues.isEmpty){
      return DialogProgressText(text:  AppLocalizations.of(context)!.loading);
    }

    leaguesWd = allLeagues.where((element) => element.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList().isNotEmpty).toList();// <LeagueWithData>[];
    if (leaguesWd.isEmpty){
      return Align(alignment: Alignment.center,  child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon on top
          const Icon(
            Icons.sports_soccer,  // Built-in Flutter icon
            size: 120,  // Icon size
            color: Color(ColorConstants.my_dark_grey), // Icon color
          ),
          const SizedBox(height: 20),  // Space between icon and text
          // Text below the icon
          Text(
            AppLocalizations.of(context)!.no_live_games,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.my_dark_grey),
            ),
          ),
        ],
      )
      );
    }

    return Scaffold(

      backgroundColor: Colors.white,

      key: UniqueKey(),

      body:
      PageStorage(

      bucket: pageBucket,
      child:
      ListView.builder(
          key: const PageStorageKey<String>(
              'pageLive'),
        // controller: scrollController,
          itemCount: leaguesWd.length,
          itemBuilder: (context, item) {
            return _buildRow(item);
          }),
    ));

  }

  Widget _buildRow(int item) {
    LeagueWithData league = leaguesWd[item];
    return LeagueExpandableTile(key: PageStorageKey<LeagueWithData>(leaguesWd.elementAt(item)),  leagueWithData: league, isAlwaysExpanded: true,  expandAll: true, events: league.events.where((element) => element.status == MatchEventStatus.INPROGRESS.statusStr).toList(), selectedOdds: [], callbackForOdds: (a)=>{}, favourites: favourites, );
  }

  List<String> getFavourites(){
    sharedPrefs.reload();
    return sharedPrefs.getListByKey(sp_fav_event_ids);
  }

  callBackForExpansion(int index){

  }
  
  

}
