import 'dart:async';

import 'package:flutter_app/enums/BetStatus.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:flutter_app/widgets/DialogTabbedLoginOrRegister.dart';
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
import '../utils/DateUtils.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/NoGames.dart';
import '../widgets/row/DialogProgressBarWithText.dart';


class OddsPage extends StatefulWidget{//}WithName {

  final Function updateUserCallback;
  final Function loginUserCallback;
  final Function registerUserCallback;
  final List<UserPrediction> selectedOdds;

  @override
  OddsPageState createState() => OddsPageState();

  const OddsPage({
    Key? key,
    required this.updateUserCallback,
    required this.loginUserCallback,
    required this.registerUserCallback,
    required this.selectedOdds,
  } ) : super(key: key);

}

class OddsPageState extends State<OddsPage> with SingleTickerProviderStateMixin{

  bool isMinimized = false;

  /*
  * Required because user can deleted selected odds from the betslip directly.
   */
  late List<UserPrediction> selectedOdds;

  int selectedIndex = -1;

  Function updateUserCallback = ()=>{ };
  Function loginUserCallback = ()=>{ };
  Function registerUserCallback = ()=>{ };

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    selectedOdds = widget.selectedOdds;
    updateUserCallback = widget.updateUserCallback;
    loginUserCallback = widget.loginUserCallback;
    registerUserCallback = widget.registerUserCallback;

    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool allEmpty = true;
    for (String key in AppContext.eventsPerDayMap.keys){
      if (AppContext.eventsPerDayMap.containsKey(key) && AppContext.eventsPerDayMap[key]!.isNotEmpty){
        allEmpty = false;
        break;
      }
    }

    if (allEmpty){
      return DialogProgressText(text: AppLocalizations.of(context)!.loading);
    }

    const int items = 5;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 2;
    double labelWidth = (width - (labelPadding * (items - 1)))  / items;

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
                tabAlignment: TabAlignment.center,
                tabs: [
                  CustomTabIcon(width: labelWidth, text: DateUtilsFt.formatDateForLabelDisplay(-2), isSelected: _tabController.index == 0,),
                  CustomTabIcon(width: labelWidth, text: DateUtilsFt.formatDateForLabelDisplay(-1), isSelected: _tabController.index == 1,),
                  CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.today, isSelected: _tabController.index == 2,),
                  CustomTabIcon(width: labelWidth, text: DateUtilsFt.formatDateForLabelDisplay(1), isSelected: _tabController.index == 3,),
                  CustomTabIcon(width: labelWidth, text: DateUtilsFt.formatDateForLabelDisplay(2), isSelected: _tabController.index == 4,),
                  ],

                onTap: (index) {
                  setState(() {
                  _tabController.index = index;
                  });
                }

          )

      ),

          body:

          PageStorage(

          bucket: pageBucket,
          child:
          TabBarView(
            controller: _tabController,
            children: [

              (AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-2)] == null
                  || AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-2)]!.isEmpty) ?
              NoGames()

                  :

              ListView.builder(
                  key: const PageStorageKey<String>('pageOdds-1'),
                  padding: const EdgeInsets.all(0),
                  itemCount:  AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-2)]?.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-2)]!.elementAt(item), item);
                  }),

              (AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-1)] == null
                  || AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-1)]!.isEmpty) ?
              NoGames()

                  :

              ListView.builder(
                  key: const PageStorageKey<String>('pageOdds0'),
                  padding: const EdgeInsets.all(0),
                  itemCount:  AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-1)]?.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(-1)]!.elementAt(item), item);
                  }),

              (AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(0)] == null
                  || AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(0)]!.isEmpty) ?
                  NoGames()

                  :

              ListView.builder(

                  key: const PageStorageKey<String>('pageOdds1'),
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(0)]?.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(0)]!.elementAt(item), item);
                  }),

              (AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(1)] == null
                  || AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(1)]!.isEmpty) ?
              NoGames()

                  :

              ListView.builder(
                  key: const PageStorageKey<String>('pageOdds2'),
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(1)]?.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(1)]!.elementAt(item), item);
                  }),


              (AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(2)] == null
                  || AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(2)]!.isEmpty) ?
              NoGames()

                  :

              ListView.builder(
                  key: const PageStorageKey<String>('pageOdds3'),
                  padding: const EdgeInsets.all(0),
                  itemCount: AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(2)]?.length,
                  itemBuilder: (context, item) {
                    return _buildRow(AppContext.eventsPerDayMap[DateUtilsFt.formattedDateWithOffset(2)]!.elementAt(item), item);
                  }),

            ],)
          ),

        floatingActionButton: FloatingActionButton(
          heroTag: 'btnOdds',
          foregroundColor: Colors.white,
          onPressed: ()=> {

            //user not valid
            if (AppContext.user.mongoUserId != Constants.defMongoId && !AppContext.user.validated){
              alertDialog('${AppLocalizations.of(context)!.mail_requires_validation} ${AppContext.user.email}' )
            }
            //user not logged
            else if (AppContext.user.mongoUserId == Constants.defMongoId){

              showDialog(context: context, builder: (context) =>
                  DialogTabbedLoginOrRegister(
                    registerCallback: registerUserCallback,
                    loginCallback: loginUserCallback,
                  )
              )

            }
            //open betslip
            else if (selectedOdds.isNotEmpty){
              showOddsDialog()
            }

            //do nothing

          },

          backgroundColor: const Color(ColorConstants.my_blue),

          child:  Text(BetUtils.finalOddOf(selectedOdds).toStringAsFixed(2), style: TextStyle(fontSize: (BetUtils.finalOddOf(selectedOdds )  < 100) ? 16 : (BetUtils.finalOddOf(selectedOdds )  < 1000) ? 15 : 12)),
        ),

      // ),
    );
  }

  Widget _buildRow(LeagueWithData league, int item) {
   return LeagueExpandableTile(key: PageStorageKey<String>('oddsLeague${league.league.league_id}$item'),  isAlwaysExpanded: false, leagueWithData: league, expandAll: selectedIndex==item, events: league.events, callbackForOdds: fixOddsCallback, selectedOdds: selectedOdds, favourites: favourites(),);
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
        ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
          content: Text('${AppLocalizations.of(context)!.max_selection} ${Constants.MAX_BET_PREDICTIONS}'), showCloseIcon: true, duration: const Duration(seconds: 5),
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
    if (bettingAmount > Constants.maxBet || bettingAmount <= 0){
      String text = AppLocalizations.of(context)!.max_bet_amount;
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text('$text ${Constants.maxBet}'),
        showCloseIcon: true,
        duration: const Duration(seconds: 5),

      ));
      return BetPlacementStatus.FAILED_INSUFFICIENT_FUNDS;
    }


    if (bettingAmount > AppContext.user.fantasyBalance.balance){
      //String msg = 'Cannot place bet. insufficient funds.';
      //alertDialogTopUp();
      return BetPlacementStatus.FAILED_INSUFFICIENT_FUNDS;
    }

    String? mongoUserId = AppContext.user.mongoUserId;
    if (mongoUserId != Constants.defMongoId && !AppContext.user.validated){
      String msg = '${AppLocalizations.of(context)!.mail_requires_validation}${AppContext.user.email}';
      alertDialog(msg);
      return BetPlacementStatus.FAILED_USER_NOT_VALIDATED;
    }else if (mongoUserId == Constants.defMongoId){
      String msg = AppLocalizations.of(context)!.login_or_register;
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
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              AppLocalizations.of(context)!.match_in_progress),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
        ));
      }

    }

    if (betPlacementStatus == BetPlacementStatus.FAIL_GENERIC) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              AppLocalizations.of(context)!.cannot_place_bet,
              ),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
        ));
      }
    }

    if (betPlacementStatus == BetPlacementStatus.FAILED_MATCH_IN_NEXT_MONTH) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              AppLocalizations.of(context)!.preds_next_month,
              ),
          showCloseIcon: true,
          duration: const Duration(seconds: 5),
        ));
      }
    }

    return betPlacementStatus;
  }



  void alertDialog(String msg) {
    showDialog(context: context, builder: (context) =>

        AlertDialog(
          title:  Text(AppLocalizations.of(context)!.action),
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

  showOddsDialog() {

    //WORKS FINE
    showDialog<BetPlacementStatus>(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          elevation: 20,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  reverse: true,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: constraints.maxHeight * 0.6, // Don't use fixed height
                    ),
                    child: IntrinsicHeight(
                      child: BetSlipWithCustomKeyboard(
                        selectedOdds: selectedOdds,
                        initialHeight: constraints.maxHeight * 0.6, // If needed
                        callbackForBetPlacement: placeBetCallback,
                        callbackForBetRemoval: removeOddCallback,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

  }

}



class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Wrap(
            children: [
              Text(AppLocalizations.of(context)!.enter_amount),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.done),
              )
            ],
          ),
        ),
      ),
    );
  }
}