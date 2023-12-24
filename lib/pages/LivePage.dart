// You have to add this manually, for some reason it cannot be added automatically
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';

import '../models/league.dart';
import '../widgets/LeagueExpandableTile.dart';

final pageBucket = PageStorageBucket();

class LivePage extends StatefulWidgetWithName {

  @override
  LivePageState createState() => LivePageState();

  final List<League> liveLeagues;

  LivePage({
    Key? key,
    required this.liveLeagues,
  } ) : super(key: key);

}

class LivePageState extends State<LivePage> with WidgetsBindingObserver{

  List<League> liveLeagues = <League>[];

  @override
  void initState(){
    liveLeagues = widget.liveLeagues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
    League league = liveLeagues[item];
    return LeagueExpandableTile(key: PageStorageKey<League>(liveLeagues.elementAt(item)), league: league, events: league.liveEvents, selectedOdds: [], callbackForOdds: (a)=>{},);
  }
  
  

}
