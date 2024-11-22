// You have to add this manually, for some reason it cannot be added automatically
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';

import '../models/LeagueWithData.dart';
import '../models/constants/MatchConstants.dart';
import '../models/context/AppContext.dart';
import '../widgets/LeagueExpandableTile.dart';

final pageBucket = PageStorageBucket();

class LivePage extends StatefulWidgetWithName {

  @override
  LivePageState createState() => LivePageState();

  final List<LeagueWithData> liveLeagues;

  LivePage({
    Key? key,
    required this.liveLeagues,
  } ) : super(key: key);

}

class LivePageState extends State<LivePage> with WidgetsBindingObserver{

  late List<LeagueWithData> liveLeagues;// = AppContext.eventsPerDayMap[MatchConstants.KEY_TODAY].where((element) => element.liveEvents.isNotEmpty);// <LeagueWithData>[];

  List<String> favourites = <String>[];

  @override
  void initState(){
    liveLeagues = widget.liveLeagues;
    favourites = getFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    // List<LeagueWithData> liveLeagues = liveLeagues.where((element) => element.liveEvents.isNotEmpty).toList();// <LeagueWithData>[];


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
          itemCount: liveLeagues.length,
          itemBuilder: (context, item) {
            return _buildRow(item);
          }),
    ));

  }

  Widget _buildRow(int item) {
    LeagueWithData league = liveLeagues[item];
    return LeagueExpandableTile(key: PageStorageKey<LeagueWithData>(liveLeagues.elementAt(item)), league: league, expandAll: true, events: league.liveEvents, selectedOdds: [], callbackForOdds: (a)=>{}, favourites: favourites);
  }

  List<String> getFavourites(){
    sharedPrefs.reload();
    return sharedPrefs.getListByKey(sp_fav_event_ids);
  }
  
  

}
