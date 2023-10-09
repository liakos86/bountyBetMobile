import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/pages/LivePage.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/widgets/BetSlipWithCustomKeyboard.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
import 'package:http/http.dart';

import '../models/UserBet.dart';
import '../models/UserPrediction.dart';
import '../models/constants/UrlConstants.dart';
import '../models/league.dart';
import '../utils/BetUtils.dart';
import '../widgets/BetSlipBottom.dart';
import '../widgets/LeagueMatchesRow.dart';


class OddsPage extends StatefulWidget {

  final Map eventsPerDayMap;

  final Function updateUserCallback;

  @override
  OddsPageState createState() => OddsPageState();

  OddsPage({
    Key? key,
    required this.updateUserCallback,
    required this.eventsPerDayMap,
    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class OddsPageState extends State<OddsPage>{

  // final ScrollController _scrollController0 = ScrollController();
  // final ScrollController _scrollController1 = ScrollController();
  // final ScrollController _scrollController2 = ScrollController();

  /*
  * Required because user can deleted selected odds from the betslip directly.
   */
  late final List<UserPrediction> selectedOdds;// = <UserPrediction>[];

  Map eventsPerDayMap = LinkedHashMap();

  Function updateUserCallback = ()=>{ };

  @override
  void initState() {
    selectedOdds = <UserPrediction>[];
    eventsPerDayMap = widget.eventsPerDayMap;
    updateUserCallback = widget.updateUserCallback;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (eventsPerDayMap.isEmpty){
      return  const Align(
          alignment: Alignment.center,
          child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Colors.blueAccent,
            backgroundColor: Colors.grey)
      ));
    }

    return DefaultTabController(
      initialIndex: 1,
      length: 3,

      child:

      Scaffold(

        backgroundColor: Colors.white,

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: true,
                indicatorColor: Colors.red,
                indicatorWeight: 6,
                unselectedLabelColor: Colors.white.withOpacity(0.3),

              tabs: [
                Tab(text: eventsPerDayMap.entries.elementAt(2).key),
                Tab(text: eventsPerDayMap.entries.elementAt(1).key),
                Tab(text: eventsPerDayMap.entries.elementAt(0).key),
              ],
            ),

      ),

          body:

          PageStorage(

          bucket: pageBucket,
          child:
          TabBarView(
            children: [
              ListView.builder(

                  key: const PageStorageKey<String>(
                      'pageOdds0'),
                  // controller: _scrollController0,
                  padding: const EdgeInsets.all(8),
                  itemCount: eventsPerDayMap.entries.elementAt(2).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(eventsPerDayMap.entries.elementAt(2).value[item], item);
                  }),

              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds1'),
                 // controller: _scrollController1,
                  padding: const EdgeInsets.all(8),
                  itemCount: eventsPerDayMap.entries.elementAt(1).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(eventsPerDayMap.entries.elementAt(1).value[item], item);
                  }),
              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds2'),
                // controller: _scrollController2,
                  padding: const EdgeInsets.all(8),
                  itemCount: eventsPerDayMap.entries.elementAt(0).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(eventsPerDayMap.entries.elementAt(0).value[item], item);
                  }),

            ],)
          ),

        floatingActionButton: FloatingActionButton(
          onPressed: ()=> {
            if (selectedOdds.isNotEmpty)
          showDialog(context: context, builder: (context) =>

          AlertDialog(

          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(2.0),
          buttonPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          elevation: 20,
          shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.only(topLeft:
          Radius.circular(10.0), topRight: Radius.circular(10.0))),
          content: Builder(
          builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height * (2/3);
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
              width: width,
              height: height,
              child : BetSlipWithCustomKeyboard(key: UniqueKey(), selectedOdds: selectedOdds, callbackForBetPlacement: placeBetCallback, callbackForBetRemoval: removeOddCallback, )
            );

          })

          ))
          },

          backgroundColor: Colors.blueAccent,

          child:  Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2), style: TextStyle(fontSize: (BetUtils.finalOddOf(selectedOdds )  < 100) ? 16 : (BetUtils.finalOddOf(selectedOdds )  < 1000) ? 15 : 12)),
        ),

      ),
    );
  }

  Widget _buildRow(League league, int item) {
   return LeagueExpandableTile(key: PageStorageKey<League>(league), league: league, events: league.events, callbackForOdds: fixOddsCallback, selectedOdds: selectedOdds);
  }

  void removeOddCallback(UserPrediction toRemove){
    selectedOdds.remove(toRemove);

    setState(() {
      selectedOdds;
    });

    if (selectedOdds.isEmpty){
      Navigator.pop(context);
    }

  }

  void fixOddsCallback(UserPrediction selectedOdd) {
    if (selectedOdds.contains(selectedOdd)){
      selectedOdds.remove(selectedOdd);
    }else{
      for (UserPrediction up in List.of(selectedOdds)){
        if (selectedOdd.eventId == up.eventId){
          selectedOdds.remove(up);
        }
      }

      selectedOdds.add(selectedOdd);
    }

    setState(() =>
      selectedOdds
    );

  }

  void placeBetCallback(double bettingAmount) async {
    if (bettingAmount <= 0 ){
      return;
    }

    String? mongoUserId = ParentPageState.user.mongoUserId;
    if (mongoUserId != Constants.defMongoUserId && !ParentPageState.user.validated){
      String msg = 'Your account requires validation. Please go to ${ParentPageState.user.email} and validate.';
      alertDialog(msg);
      return;
    }else if (mongoUserId == Constants.defMongoUserId){
      String msg = 'Please login/register at the top left in order to bet.';
      alertDialog(msg);
      return;
    }

    selectedOdds.forEach((element) {element.event = ParentPageState.findEvent(element.eventId);});
    UserBet newBet = UserBet(userMongoId: mongoUserId , predictions: List.of(selectedOdds), betAmount: bettingAmount);
    var encodedBet = jsonEncode(newBet.toJson());

    try {
      var userResponse = await post(Uri.parse(UrlConstants.POST_PLACE_BET),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: encodedBet,
          encoding: Encoding.getByName("utf-8")).timeout(
          const Duration(seconds: 20));

      var responseDec = jsonDecode(userResponse.body);
      User userFromServer = User.fromJson(responseDec);
      updateUserCallback.call(userFromServer, newBet);

      setState(() {
        selectedOdds.clear();
      });

    }catch(e){
      print(e);
    }
  }

  void alertDialog(String msg) {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: Text('Registration'),
          content: Text(msg),
          elevation: 20,
        ));
  }

}