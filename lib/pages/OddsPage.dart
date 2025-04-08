import 'dart:async';

import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
import 'package:flutter_app/widgets/dialog/DialogTextWithButtons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/enums/BetPlacementStatus.dart';
import 'package:flutter_app/helper/SharedPrefs.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/pages/LivePage.dart';
import 'package:flutter_app/widgets/BetSlipWithCustomKeyboard.dart';
import 'package:flutter_app/widgets/LeagueExpandableTile.dart';
import 'package:intl/intl.dart';

import '../models/UserBet.dart';
import '../models/UserPrediction.dart';
import '../models/LeagueWithData.dart';
import '../models/beans/PlaceBetResponseBean.dart';
import '../models/constants/ColorConstants.dart';
import '../models/context/AppContext.dart';
import '../utils/BetUtils.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/DialogProgressBarWithText.dart';


class OddsPage extends StatefulWidget{//}WithName {

  // final Map eventsPerDayMap;

  final Function updateUserCallback;
  final Function loginUserCallback;
  final Function registerUserCallback;
  final Function topUpCallback;

  final List<UserPrediction> selectedOdds;

  // @override
  // StatefulElement createElement() {
  //   setName('Today\'s Odds');
  //   // TODO: implement createElement
  //   return super.createElement();
  // }

  @override
  OddsPageState createState() => OddsPageState();

  OddsPage({
    Key? key,
    required this.updateUserCallback,
    required this.loginUserCallback,
    required this.registerUserCallback,
    required this.selectedOdds,
    required this.topUpCallback
  } ) : super(key: key);

}

class OddsPageState extends State<OddsPage> with SingleTickerProviderStateMixin{

  bool isMinimized = false;

  /*
  * Required because user can deleted selected odds from the betslip directly.
   */
  late List<UserPrediction> selectedOdds;// = <UserPrediction>[];

  int selectedIndex = -1;

  Function updateUserCallback = ()=>{ };
  Function loginUserCallback = ()=>{ };
  Function registerUserCallback = ()=>{ };
  Function topUpCallback = ()=>{ };

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    selectedOdds = widget.selectedOdds;
    // eventsPerDayMap = widget.eventsPerDayMap;
    updateUserCallback = widget.updateUserCallback;
    loginUserCallback = widget.loginUserCallback;
    registerUserCallback = widget.registerUserCallback;
    topUpCallback = widget.topUpCallback;

    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    const int items = 5;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 4;
    double labelWidth = (width - (labelPadding * (items - 1)))  / items;

    bool allEmpty = true;
    for (String key in AppContext.eventsPerDayMap.keys){
      if (AppContext.eventsPerDayMap[key].length > 0){
        allEmpty = false;
        break;
      }
    }

    if (allEmpty){
      return const DialogProgressText(text: 'Loading...');
    }

    return

      Scaffold(

        backgroundColor: Colors.grey.shade100,

          appBar: AppBar(
            toolbarHeight: 5,
            backgroundColor: Colors.black87,

            bottom:
                TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
                indicator: const BoxDecoration(),
                controller: _tabController,

                isScrollable: true,
                // indicatorColor: Colors.redAccent,
                // indicatorWeight: 6,
                tabAlignment: TabAlignment.center,
                // unselectedLabelColor: Colors.black54.withOpacity(0.2),

                tabs: [
                  CustomTabIcon(width: labelWidth, text: getDateWithOffset(-2), isSelected: _tabController.index == 0,),
                  CustomTabIcon(width: labelWidth, text: getDateWithOffset(-1), isSelected: _tabController.index == 1,),
                  CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.today, isSelected: _tabController.index == 2,),
                  CustomTabIcon(width: labelWidth, text: getDateWithOffset(1), isSelected: _tabController.index == 3,),
                  CustomTabIcon(width: labelWidth, text: getDateWithOffset(2), isSelected: _tabController.index == 4,),
                ],

                onTap: (index) {
                  setState(() {
                  _tabController.index = index;
                  });
                }

          )



            // PreferredSize(
            //   preferredSize: _tabBar.preferredSize,
            //   child: ColoredBox(
            //     color: Colors.deepOrange.shade100,
            //     child: _tabBar,
            //   ),
            // ),

      ),

          body:

          PageStorage(

          bucket: pageBucket,
          child:
          TabBarView(
            controller: _tabController,
            children: [

              ListView.builder(

                  key: const PageStorageKey<String>(
                      'pageOdds0'),
                  // controller: _scrollController0,
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(2).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(2).value[item], item);
                  }),

              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds1'),
                 // controller: _scrollController1,
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(1).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(1).value[item], item);
                  }),

              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds2'),
                  // controller: _scrollController1,
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(1).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(1).value[item], item);
                  }),

              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds3'),
                  // controller: _scrollController1,
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap.entries.elementAt(1).value.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap.entries.elementAt(1).value[item], item);
                  }),


              ListView.builder(
                  key: const PageStorageKey<String>(
                      'pageOdds4'),
                // controller: _scrollController2,
                  padding: const EdgeInsets.all(0),
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

            if (AppContext.user.mongoUserId != Constants.defMongoId && !AppContext.user.validated){
              alertDialog('Your account requires validation. Please check your inbox at ${AppContext.user.email} and validate.')
            }else if (AppContext.user.mongoUserId == Constants.defMongoId){

          showDialog(context: context, builder: (context) =>

              DialogTabbedLoginOrRegister(
                registerCallback: registerUserCallback,
                loginCallback: loginUserCallback,
              )
          )



            } else if (selectedOdds.isNotEmpty)

              showDialog(context: context, builder: (context) =>

              AlertDialog(

                backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(0),
          buttonPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          elevation: 20,


          content:

          Builder(
          builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height =  (selectedOdds.length * 100) + 100 < MediaQuery.of(context).size.height * (2/3) ? ((selectedOdds.length * 100) + 100).toDouble() : MediaQuery.of(context).size.height * (2/3);//  MediaQuery.of(context).size.height * (2/3);
          var width = MediaQuery.of(context).size.width;

          return
            SizedBox(
              width: width,
              height: height,
              child : BetSlipWithCustomKeyboard(key: UniqueKey(), initialHeight: height, selectedOdds: selectedOdds, callbackForBetPlacement: placeBetCallback, callbackForBetRemoval: removeOddCallback, )
            );

          })

          ))
          },

          backgroundColor: const Color(ColorConstants.my_green),

          child:  Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2), style: TextStyle(fontSize: (BetUtils.finalOddOf(selectedOdds )  < 100) ? 16 : (BetUtils.finalOddOf(selectedOdds )  < 1000) ? 15 : 12)),
        ),

      // ),
    );
  }

  Widget _buildRow(LeagueWithData league, int item) {
   return LeagueExpandableTile(key: PageStorageKey<LeagueWithData>(league),  isAlwaysExpanded: false, leagueWithData: league, expandAll: selectedIndex==item, events: league.events, callbackForOdds: fixOddsCallback, selectedOdds: selectedOdds, favourites: favourites(),);
  }

  void removeOddCallback(UserPrediction? toRemove){

    if (toRemove == null){
      selectedOdds.clear();
    }else{
      selectedOdds.remove(toRemove);
    }


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

      if (Constants.MAX_BET_PREDICTIONS < selectedOdds.length){
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          content: Text('Max selections size is ${Constants.MAX_BET_PREDICTIONS}'), showCloseIcon: true, duration: Duration(seconds: 5),
        ));

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
    if (bettingAmount <= 0 || bettingAmount > AppContext.user.balance.balance){
      //String msg = 'Cannot place bet. insufficient funds.';
      alertDialogTopUp();
      return BetPlacementStatus.FAILED_INSUFFICIENT_FUNDS;
    }

    String? mongoUserId = AppContext.user.mongoUserId;
    if (mongoUserId != Constants.defMongoId && !AppContext.user.validated){
      String msg = 'Your account requires validation. Please go to ${AppContext.user.email} and validate.';
      alertDialog(msg);
      return BetPlacementStatus.FAILED_USER_NOT_VALIDATED;
    }else if (mongoUserId == Constants.defMongoId){
      String msg = 'Please login/register at the top left in order to bet.';
      alertDialog(msg);
      return BetPlacementStatus.FAILED_USER_NOT_VALIDATED;
    }

    UserBet newBet = UserBet(userMongoId: mongoUserId, betId:'', predictions: List.of(selectedOdds), betAmount: bettingAmount, betStatus: BetStatus.PENDING, betPlacementMillis: 0);

    PlaceBetResponseBean responseBean = await HttpActionsClient.placeBet(newBet);
    BetPlacementStatus betPlacementStatus = BetPlacementStatus.ofStatusText(responseBean.betPlacementStatus);

    if (betPlacementStatus == BetPlacementStatus.PLACED) {
      newBet.betPlacementStatus = BetPlacementStatus.PLACED;
      newBet.betId = responseBean.betId;
      newBet.betPlacementMillis = DateTime.now().millisecondsSinceEpoch;
      updateUserCallback.call(newBet);
    }

    if (betPlacementStatus == BetPlacementStatus.FAILED_MATCH_IN_PROGRESS) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Cannot place bet. Match in progress.'),
          showCloseIcon: true,
          duration: Duration(seconds: 5),
        ));
      }

    }

    if (betPlacementStatus == BetPlacementStatus.FAIL_GENERIC) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Cannot place bet. Please try again in a while.'),
          showCloseIcon: true,
          duration: Duration(seconds: 5),
        ));
      }
    }

    if (betPlacementStatus == BetPlacementStatus.FAILED_MATCH_IN_NEXT_MONTH) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Cannot place bet. Please select predictions only for current month'),
          showCloseIcon: true,
          duration: Duration(seconds: 5),
        ));
      }
    }

    return betPlacementStatus;
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
    return  sharedPrefs.getListByKey(sp_fav_event_ids);
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

  Future<bool> callbackForExpansion(int index) async{


    setState(() {
      selectedIndex = index;
    });

    return true;
  }

  void alertDialogTopUp() {
    showDialog(context: context, builder: (context) =>
      DialogTextWithButtons(topUpCallback: topUpCallback)
    );
  }

}