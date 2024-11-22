import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_app/models/interfaces/StatefulWidgetWithName.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/enums/BetPredictionStatus.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/pages/LivePage.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_app/widgets/BetSlipWithCustomKeyboard.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../models/League.dart';
import '../models/UserBet.dart';
import '../models/UserPrediction.dart';
import '../models/constants/UrlConstants.dart';
import '../models/LeagueWithData.dart';
import '../models/context/AppContext.dart';
import '../utils/BetUtils.dart';


class OddsPage extends StatefulWidgetWithName {

  // final Map eventsPerDayMap;

  final Function updateUserCallback;

  final List<UserPrediction> selectedOdds;

  @override
  StatefulElement createElement() {
    setName('Today\'s Odds');
    // TODO: implement createElement
    return super.createElement();
  }

  @override
  OddsPageState createState() => OddsPageState();

  OddsPage({
    Key? key,
    required this.updateUserCallback,
    // required this.eventsPerDayMap,
    required this.selectedOdds


  } ) : super(key: key);

}

class OddsPageState extends State<OddsPage>{

  /*
  * Required because user can deleted selected odds from the betslip directly.
   */
  late final List<UserPrediction> selectedOdds;// = <UserPrediction>[];

  // Map eventsPerDayMap = LinkedHashMap();

  Function updateUserCallback = ()=>{ };

  @override
  void initState() {
    selectedOdds = widget.selectedOdds;
    // eventsPerDayMap = widget.eventsPerDayMap;
    updateUserCallback = widget.updateUserCallback;
    super.initState();
  }

  TabBar get _tabBar => TabBar(
    labelStyle: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.normal),
    isScrollable: true,
    indicatorColor: Colors.redAccent,
    indicatorWeight: 6,
    tabAlignment: TabAlignment.center,
    unselectedLabelColor: Colors.black54.withOpacity(0.2),
    tabs: [
      Tab(text: getDateWithOffset(-1)),
      Tab(text: AppLocalizations.of(context)!.today),
      Tab(text: getDateWithOffset(1)),
    ],
  );

  @override
  Widget build(BuildContext context) {

    if (AppContext.eventsPerDayMap.isEmpty){
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

    return


    DefaultTabController(
      initialIndex: 1,
      length: AppContext.eventsPerDayMap.keys.length,

      child:

      Scaffold(

        backgroundColor: Colors.grey[100],

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:
            PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.deepOrange.shade100,
                child: _tabBar,
              ),
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
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(2).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(2).value[item], item);
                  }),

              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds1'),
                 // controller: _scrollController1,
                  padding: const EdgeInsets.all(8),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(1).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(1).value[item], item);
                  }),


              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds2'),
                // controller: _scrollController2,
                  padding: const EdgeInsets.all(8),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(0).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(0).value[item], item);
                  }),

            ],)
          ),

        floatingActionButton: FloatingActionButton(
          heroTag: 'btnOdds',
          foregroundColor: Colors.white,
          onPressed: ()=> {

            if (AppContext.user.mongoUserId != Constants.defMongoUserId && !AppContext.user.validated){
              alertDialog('Your account requires validation. Please go to ${AppContext.user.email} and validate.')
            }else if (AppContext.user.mongoUserId == Constants.defMongoUserId){
              alertDialog('Please login/register at the top left in order to bet.')
            } else if (selectedOdds.isNotEmpty)

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

  Widget _buildRow(LeagueWithData league, int item) {
   return LeagueExpandableTile(key: PageStorageKey<LeagueWithData>(league), league: league, expandAll: false, events: league.events, callbackForOdds: fixOddsCallback, selectedOdds: selectedOdds, favourites: favourites(),);
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

      if (Constants.MAX_BET_PREDICTIONS == selectedOdds.length){
        Fluttertoast.showToast(msg: 'Max bets size');
        return;
      }

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

  Future<BetPlacementStatus> placeBetCallback(double bettingAmount) async {
    if (bettingAmount <= 0 ){
      return BetPlacementStatus.FAILED_INSUFFICIENT_FUNDS;
    }


    String? mongoUserId = AppContext.user.mongoUserId;
    if (mongoUserId != Constants.defMongoUserId && !AppContext.user.validated){
      String msg = 'Your account requires validation. Please go to ${AppContext.user.email} and validate.';
      alertDialog(msg);
      return BetPlacementStatus.FAILED_USER_NOT_VALIDATED;
    }else if (mongoUserId == Constants.defMongoUserId){
      String msg = 'Please login/register at the top left in order to bet.';
      alertDialog(msg);
      return BetPlacementStatus.FAILED_USER_NOT_VALIDATED;
    }

    //selectedOdds.forEach((element) {element.event = ParentPageState.findEvent(element.eventId);});
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

      // var responseDec = jsonDecode(userResponse.body);
      //User userFromServer = User.fromJson(responseDec);

      BetPlacementStatus betPlacementStatus = BetPlacementStatus.ofStatusText(userResponse.body);

      if (betPlacementStatus != BetPlacementStatus.PLACED){
        return betPlacementStatus;
      }

      updateUserCallback.call(newBet);

      setState(() {
        selectedOdds.clear();
      });

      return BetPlacementStatus.PLACED;

    }catch(e){
      print(e);
      return BetPlacementStatus.FAIL_GENERIC;
    }
  }

  void alertDialog(String msg) {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title: const Text('Registration'),
          content: Text(msg),
          elevation: 20,
        ));
  }

  favourites() {
    sharedPrefs.reload();
    return sharedPrefs.getListByKey(sp_fav_event_ids);
  }

  String getDateWithOffset(int offset) {
    // Get today's date
    DateTime today = DateTime.now();

    // Calculate the new date by adding the offset
    DateTime newDate = today.add(Duration(days: offset));

    // Format the new date in "DD/MM" format
    String formattedDate = DateFormat('dd/MM').format(newDate);

    return formattedDate;
  }

}