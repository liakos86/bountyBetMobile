import 'dart:async';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/Constants.dart';
import 'package:flutter_app/models/context/AppContext.dart';
import 'package:flutter_app/utils/client/HttpActionsClient.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../enums/FantasyLeagueStatus.dart';
import '../helper/SharedPrefs.dart';
import '../models/FantasyLeagueInvitation.dart';
import '../models/User.dart';
import '../models/UserBet.dart';
import '../models/constants/ColorConstants.dart';
import '../models/constants/PurchaseConstants.dart';
import '../widgets/custom/FantasyLeagueCard.dart';
import '../widgets/custom/FantasyLeagueCompletedCard.dart';
import '../widgets/dialog/DialogFantasyLeagueWinner.dart';
import '../widgets/dialog/DialogTextExtraLeagues.dart';
import '../widgets/dialog/DialogTextExtraUsers.dart';
import '../widgets/dialog/DialogTextTopUp.dart';
import '../widgets/row/FantasyLeagueInvitationRow.dart';
import '../widgets/dialog/DialogWizardLeagueNameStep1.dart';

import 'package:flutter/widgets.dart';

import '../models/FantasyLeague.dart';
import '../widgets/CustomTabIcon.dart';
import '../widgets/row/UserBetRow.dart';
import 'LivePage.dart';


class MyFantasyLeaguesPage extends StatefulWidget{//}WithName{

  final Function loginOrRegisterCallback;

  final FantasyLeague fantasyLeague;


  @override
  MyFantasyLeaguesPageState createState() => MyFantasyLeaguesPageState(loginOrRegisterCallback, fantasyLeague);

  MyFantasyLeaguesPage({
    Key? key,
    required this.loginOrRegisterCallback,
    required this.fantasyLeague

    //setName('Today\'s Odds')

  } ) : super(key: key);

}

class MyFantasyLeaguesPageState extends State<MyFantasyLeaguesPage>  with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  StreamSubscription<List<PurchaseDetails>>? subscription;
  bool available = false;
  bool isMinimized = false;

  bool alertDialogOpen = false;

  bool offline = false;

  /*
   * Make o copy of the bets
   */
  List<UserBet> bets = List.of(AppContext.user.userBets);

  FantasyLeague fantasyLeague;

  List<FantasyLeague> completedFantasyLeagues = <FantasyLeague>[];

  List<FantasyLeague> invitations = <FantasyLeague>[];

  Function loginOrRegisterCallback;

  MyFantasyLeaguesPageState(this.loginOrRegisterCallback, this.fantasyLeague);

  late TabController _tabController;

  GlobalKey  fantasyLeagueKey = GlobalKey();

  @override
  void dispose() {
    _tabController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is minimized or moved to the background
      setState(() {
        isMinimized = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      // App is active again
      print('RESUMED!!!!!!!');
      setState(() {
        isMinimized = false;
      });
    }
  }


  @override
  void initState(){
    loginOrRegisterCallback = widget.loginOrRegisterCallback;
    fantasyLeague = widget.fantasyLeague;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // if (AppContext.user.mongoUserId != Constants.defMongoId) {
    //
    // }

    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!isMinimized) {
      restorePurchases();      //);
      }
    }
    );

    updateFantasyLeagues();
    Timer.periodic(const Duration(seconds: 45), (timer) {
      if (!isMinimized) {
         updateFantasyLeagues();
      }
    }
    );

    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isMinimized) {
        updateBets(AppContext.user.userBets);//update the copy from the new bets
      }
    });


    _initializeInAppPurchases();

    subscription = inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      handlePurchaseUpdates(purchaseDetailsList);
    },onDone: () => subscription?.cancel(), onError: (error) {
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.purchase_error), showCloseIcon: true, duration: const Duration(seconds: 5),
        ));
      }
      // Handle errors during the purchase flow.
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



   if (AppContext.user.mongoUserId == Constants.defMongoId){
      return

        Align(
          alignment: Alignment.center,
          child:
          FloatingActionButton.extended(
            heroTag: 'btnMyFantasyLeaguesLogin',
            icon: const Icon(Icons.navigation),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            onPressed: () => { loginOrRegisterCallback.call()
               },
            label: const Text('Login/Register'),
      ));
    }

   // if (!leagueFetched){
   //   return const Center(child: CircularProgressIndicator(color: Color(ColorConstants.my_green),));
   // }

   const int items = 4;
   double width = MediaQuery.of(context).size.width;
   const double labelPadding = 4;
   double labelWidth = (width - (labelPadding * (items - 1))) / items;

    return DefaultTabController(
      length: items,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 5,
         backgroundColor: Colors.black87,

          bottom: TabBar(
              // isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
            indicator: const BoxDecoration(),
            controller: _tabController,

            tabs: [
              CustomTabIcon(width: labelWidth, text: 'Current League', isSelected: _tabController.index == 0,),
              CustomTabIcon(width: labelWidth, text: 'Predictions', isSelected: _tabController.index == 1,),
              CustomTabIcon(width: labelWidth,  text: 'Invitations', isSelected: _tabController.index == 2,),
              CustomTabIcon(width: labelWidth,  text: 'Past Leagues', isSelected: _tabController.index == 3,),
            ],

            onTap: (index) {
              setState(() {
                _tabController.index = index;
              });
            }
          ),


        ),

        body:

            PageStorage(

          bucket: pageBucket,
        child:
        TabBarView(
          controller: _tabController,
          children: [

            (offline)?
            Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    const Icon(
                      Icons.network_check,  // Built-in Flutter icon
                      size: 60,  // Icon size
                      color: Colors.grey, // Icon color
                    ),
                    const SizedBox(height: 20),
                    // Text below the icon
                    Text(
                      'You are offline',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.my_dark_grey),
                      ),
                    ),
                  ],
                )
            )            :

            (AppContext.user.fantasyLeagueMongoId == null) ?

            Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              DialogWizardLeagueNameStep1(
                                  updateCallback: update,
                                  alertDialogExtraLeaguesCallback: alertDialogExtraLeagues,
                                  products: products),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create League"),
                    ),

                  ],
                )
            )

                :


            fantasyLeague.mongoId != Constants.defMongoId ?


        FantasyLeagueCard(
          fantasyLeague: fantasyLeague,
          topUpCallback: promptDialogTopup,
          extraLeaguesAlertCallback: alertDialogExtraLeagues,
          extraUsersAlertCallback: alertDialogExtraUsers,
          key: fantasyLeagueKey,
          products: products,
          onOptOut: () {

            optout();


            print("Opted out!");
          },
          onInviteEmail: inviteUserByEmail,
        )

                : SizedBox(),


            (bets.isEmpty) ?

            Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    const Icon(
                      Icons.sports_soccer,  // Built-in Flutter icon
                      size: 60,  // Icon size
                      color: Colors.grey, // Icon color
                    ),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    Text(
                      AppLocalizations.of(context)!.no_pending_bets,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.my_dark_grey),
                      ),
                    ),
                  ],
                )
            )

                :


            ListView.builder(
                key: const PageStorageKey<String>(
                    'pageBetsPending'),
                // padding: const EdgeInsets.all(8),
                itemCount: bets.length,
                itemBuilder: (context, item) {
                  UserBet bet = bets[item];
                  return _buildUserBetRow(bet, 'pending$item${bet.betId}');
                }),




            (invitations.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    const Icon(
                      Icons.sports_soccer,  // Built-in Flutter icon
                      size: 60,  // Icon size
                      color: Colors.grey, // Icon color
                    ),
                    const SizedBox(height: 20),  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No invitations',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.my_dark_grey),
                      ),
                    ),
                  ],
                )
            )

                :

            ListView.builder(
              key: const PageStorageKey<String>('pageLeaguesInvitations'),
              padding: const EdgeInsets.all(8),
              itemCount: invitations.length,
              itemBuilder: (context, item) {
                return _buildInvitationRow(invitations[item], 'inv$item${invitations[item].mongoId}');
              },
            ),
            


            (completedFantasyLeagues.isEmpty) ?

            const Align(alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon on top
                    const Icon(
                      Icons.sports_soccer,  // Built-in Flutter icon
                      size: 60,  // Icon size
                      color: Colors.grey, // Icon color
                    ),
                    const SizedBox(height: 20),  // Space between icon and text  // Space between icon and text
                    // Text below the icon
                    const Text(
                      'No completed leagues',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(ColorConstants.my_dark_grey),
                      ),
                    ),
                  ],
                )
            )

                :

            ListView.builder(
              key: const PageStorageKey<String>('pageLeaguesCompleted'),
              padding: const EdgeInsets.all(8),
              itemCount: completedFantasyLeagues.length,
              itemBuilder: (context, item) {
                return _buildCompletedLeagueRow(completedFantasyLeagues[item], 'comp$item${completedFantasyLeagues[item].mongoId}');
              },
            ),

          ],)
            )

        ),
    );

  }

  void updateFantasyLeagues() async{
    SharedPreferences sh_prefs =  await SharedPreferences.getInstance();

    String? mongoUserId = AppContext.user.mongoUserId;
    if (mongoUserId == Constants.defMongoId){
      mongoUserId =  sh_prefs.getString(Constants.mongoId);
      if (mongoUserId == null){
        return;
      }
    }

    List<FantasyLeague> leagues = await HttpActionsClient.getFantasyLeaguesAsync(mongoUserId);
    if (leagues.length == 1 && leagues[0].mongoId == Constants.offlineMongoId){
      if (!mounted){
        return;
      }

      setState(() {
        offline = true;
      });

      return;
    }

    if (!mounted){
      return;
    }

    if (offline){
      setState(() {
        offline = false;
      });
    }


      String? fantasyLeagueMongoId = AppContext.user.fantasyLeagueMongoId ;
      fantasyLeagueMongoId ??= sh_prefs.getString(sp_fantasy_league_id);

    if (fantasyLeagueMongoId != null) {
      FantasyLeague? fantasyLeagueIncoming = leagues.firstWhereOrNull((element) => element.mongoId == AppContext.user.fantasyLeagueMongoId);
      if (fantasyLeagueIncoming != null){
          fantasyLeague.copyFrom(fantasyLeagueIncoming);
          fantasyLeague.invitations.sort();
          sharedPrefs.updateFantasyLeagueId(fantasyLeagueIncoming.mongoId);

      }
    }else{
      fantasyLeague.copyFrom(FantasyLeague.defLeague());
      sharedPrefs.remove(sp_fantasy_league_id);
    }


    List<FantasyLeague> invitationsIncoming = (leagues.where((e) => e.isInvitation && e.users.isNotEmpty && e.status != FantasyLeagueStatus.ABANDONED.statusCode).toList());
    for (FantasyLeague invitationIncoming in invitationsIncoming){
      FantasyLeague? invitationExisting = invitations.firstWhereOrNull((element) => element.mongoId == invitationIncoming.mongoId);
      if (invitationExisting != null){
        invitationExisting.copyFrom(invitationIncoming);
      }else{
        invitations.add(invitationIncoming);
      }
    }

    for (FantasyLeague invitationExisting in List.of(invitations)){
      FantasyLeague? invitationIncoming = invitationsIncoming.firstWhereOrNull((element) => element.mongoId == invitationExisting.mongoId);
      if (invitationIncoming == null){
        invitations.remove(invitationExisting);
      }
    }

    //TODO

    List<FantasyLeague> completedLeaguesIncoming = (leagues.where((e) => e.status == FantasyLeagueStatus.COMPLETED.statusCode && !e.isInvitation).toList());
    for (FantasyLeague completedIncoming in completedLeaguesIncoming){
      FantasyLeague? completedExisting = completedFantasyLeagues.firstWhereOrNull((element) => element.mongoId == completedIncoming.mongoId);
      if (completedExisting != null){
        completedExisting.copyFrom(completedIncoming);
      }else{
        completedFantasyLeagues.add(completedIncoming);
      }
    }

    for (FantasyLeague completedExisting in List.of(completedFantasyLeagues)){
      FantasyLeague? completedIncoming = completedLeaguesIncoming.firstWhereOrNull((element) => element.mongoId == completedExisting.mongoId);
      if (completedIncoming == null){
        completedFantasyLeagues.remove(completedExisting);
      }
    }

    completedFantasyLeagues.sort();

    if (!mounted){
      return;
    }

    setState(() {
      // leagueFetched = true;
      invitations;
      fantasyLeague;
      // fantasyLeague.users;
      completedFantasyLeagues;
    });

    fantasyLeagueKey.currentState?.setState(() {
      fantasyLeague;
    });

    checkCompletedLeagueNotification();

  }
  Widget _buildInvitationRow(FantasyLeague league, String key) {
    return FantasyLeagueInvitationRow(
      key: PageStorageKey<String>(key),
      league: league,
      // onAccept: () => _showAcceptConfirmation(league),
      // onDecline: () => _showDeclineConfirmation(league),
    );
  }


  void optout() async{
    User user = await HttpActionsClient.optOutFantasyLeague();
    if (user.fantasyLeagueMongoId == null){
      setState(() {
        fantasyLeague.copyFrom(FantasyLeague.defLeague());
        AppContext.user.fantasyLeagueMongoId = null;
      });
    }
  }

  void updateBets(List<UserBet> userBets) {
    for(UserBet incomingBet in userBets){
      UserBet existing = bets.firstWhere((element) => element.betId == incomingBet.betId, orElse: () => UserBet.defBet());
      if (existing.betId != Constants.defMongoId){
        existing.copyFrom(incomingBet);
      }else{
        bets.add(incomingBet);
      }
    }

    for(UserBet existingBet in List.of(bets)){
      UserBet incoming = userBets.firstWhere((element) => element.betId == existingBet.betId, orElse: () => UserBet.defBet());
      if (incoming.betId == Constants.defMongoId){
        bets.remove(existingBet);
      }
    }

    bets.sort();
    if (!mounted){
      return;
    }

    setState((){
      bets;
    });
  }

  Widget _buildUserBetRow(UserBet bet, String key) {

    return UserBetRow(key: PageStorageKey<String>(key), bet: bet);
  }

  void promptDialogTopup(String productId) {
    if (products.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No products available'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    ProductDetails? selected;
    for(ProductDetails product in products) {
      if (productId == product.id) {
        selected = product;
      }
    }

    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product not found $productId'), showCloseIcon: true, duration: const Duration(seconds: 5),
      ));

      return;
    }

    buyProduct(selected);
  }

  void promptDialogExtraLeagues() {
    if (products.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No products available'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    ProductDetails? selected;
    for(ProductDetails product in products) {
      if (PurchaseConstants.extra_leagues == product.id) {
        selected = product;
      }
    }

    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product not found ${PurchaseConstants.extra_leagues}'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    buyProduct(selected);
  }

  void promptDialogExtraUsers() {
    if (products.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No products available'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    ProductDetails? selected;
    for(ProductDetails product in products) {
      if (PurchaseConstants.extra_users == product.id) {
        selected = product;
      }
    }

    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product not found ${PurchaseConstants.extra_users}'), showCloseIcon: true, duration: Duration(seconds: 5),
      ));

      return;
    }

    buyProduct(selected);
  }

  Future<void> _initializeInAppPurchases() async {
    final bool isAvailable = await inAppPurchase.isAvailable();


    setState(() {
      available = isAvailable;
    });

    if (isAvailable) {

      final ProductDetailsResponse response = await inAppPurchase.queryProductDetails(PurchaseConstants.productIds);
      if (response.error == null) {
        setState(() {
          products = response.productDetails;
        });
      }else{
        print('PRODUCTS ERROR');
      }
    }
  }

  Future<void> handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async{
    setState(() {
      purchases.addAll(purchaseDetailsList);
    });

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {

      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
        //bool isValid = true; // TODO: server await verifyPurchaseOnServer(purchaseDetails);
        if (purchaseDetails.pendingCompletePurchase) {
          deliverProduct(purchaseDetails);
        }else{
          final InAppPurchaseAndroidPlatformAddition  androidAddition =
          inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

          if (purchaseDetails.productID != PurchaseConstants.extra_leagues && purchaseDetails.productID != PurchaseConstants.extra_users) {
            await androidAddition.consumePurchase(purchaseDetails);
          }

        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text( '${AppLocalizations.of(context)!.purchase_error} ${purchaseDetails.error}'), showCloseIcon: true, duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  /*
   * A purchase is sent here in order to be validated on server and then completed.
   * If server validation fails, we keep the purchase in the shared prefs in order to be retried in 30 seconds.
   */
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async{

    try {
      double? success = await sendPurchaseToServer(purchaseDetails);
      if (success!=null && success > 0) {

        inAppPurchase.completePurchase(purchaseDetails);

        final InAppPurchaseAndroidPlatformAddition  androidAddition =
        inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

        if (purchaseDetails.productID != PurchaseConstants.extra_leagues && purchaseDetails.productID != PurchaseConstants.extra_users) {
          await androidAddition.consumePurchase(purchaseDetails);
        }

        setState(() {
          for (var u in fantasyLeague.users) {
            u.fantasyBalance.balance += success;
          }
        }
        );

      } else {

        if (purchaseDetails.productID == PurchaseConstants.extra_leagues || purchaseDetails.productID == PurchaseConstants.extra_users) {
          //TODO: ALERt SUCCESS
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(AppLocalizations.of(context)!.purchase_handling),
            showCloseIcon: true,
            duration:  const Duration(seconds: 5),
          ));
        }

      }
    } catch (e) {
    }

  }

  Future<void> restorePurchases() async {
    if (AppContext.user.mongoUserId == Constants.defMongoId){
      return;
    }

    await inAppPurchase.restorePurchases();
  }

  void buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    if (productDetails.id == PurchaseConstants.extra_leagues || productDetails.id == PurchaseConstants.extra_users){
      inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }else {
      inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    }
  }

  Future<double?> sendPurchaseToServer(PurchaseDetails purchase) async {
    // For Google Play
    if (purchase.verificationData.source == 'google_play') {
      double? verified = await _verifyWithGoogle(purchase);
      return verified;
    }
    // For Apple App Store
    else if (purchase.verificationData.source == 'app_store') {
      return await _verifyWithApple(purchase);
    }
    return null;
  }

// Mock Google Play verification (Replace with your backend logic)
  Future<double?> _verifyWithGoogle(PurchaseDetails purchase) async {
    // final String purchaseToken = purchase.verificationData.serverVerificationData;

    // Send token to your backend for validation
    return await verifyPurchaseWithServer(purchase);
  }

// Mock Apple verification (Replace with your backend logic)
  Future<double?> _verifyWithApple(PurchaseDetails purchase) async {
    // final String receiptData = purchase.verificationData.serverVerificationData;
    return await verifyPurchaseWithServer(purchase);
  }

  Future<double?> verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    return await HttpActionsClient.verifyPurchase(purchaseDetails); // Simulating network delay
  }

  void update(FantasyLeague league){
    setState(() {
      fantasyLeague.copyFrom(league);
      AppContext.user.fantasyLeagueMongoId = league.mongoId;
    }
    );
  }


  void confirmWinner(bool dontShowAgain, String mongoId){
    alertDialogOpen = false;
    if (dontShowAgain) {
      print('ACKING ' + mongoId);
      sharedPrefs.appendAckLeagueId(mongoId);
    }
  }


  void alertFantasyLeagueLeaderBoard(FantasyLeague completedLeague) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => DialogFantasyLeagueWinner(
          league: completedLeague,
          confirmWinnerCallback: confirmWinner,
        ),
      );
    });
  }

  void checkCompletedLeagueNotification() async{
    if (alertDialogOpen){
      return;
    }

    FantasyLeague maxDtEndLeague = FantasyLeague.defLeague();
    if (completedFantasyLeagues.isNotEmpty) {
      maxDtEndLeague = completedFantasyLeagues.reduce((a, b) =>
      a.dtEnd.isAfter(b.dtEnd) ? a : b);

      print('League with max dtEnd: ${maxDtEndLeague.mongoId}');
    } else {
      return;
    }

    bool isAck = await sharedPrefs.isFantasyLeagueAcknowledged(maxDtEndLeague.mongoId);
    if (isAck){
      print('ACK ALREADY League with max dtEnd: ${maxDtEndLeague.mongoId}');
      return;
    }

    alertDialogOpen = true;
    alertFantasyLeagueLeaderBoard(maxDtEndLeague);
  }

  Widget _buildCompletedLeagueRow(FantasyLeague completedFantasyLeague, String key) {
    return FantasyLeagueCompletedCard(fantasyLeague: completedFantasyLeague, key: PageStorageKey<String>(key));
  }



  Future<FantasyLeagueInvitation> inviteUserByEmail(String email)async{
    FantasyLeagueInvitation invitation = FantasyLeagueInvitation(email: email);
    invitation = await HttpActionsClient.createFantasyLeagueInvitation(invitation);
    // print('Invited: $email');
    return invitation;
  }

  void alertDialogExtraLeagues() {
    showDialog(context: context, builder: (context) =>
        DialogTextExtraLeagues(extraLeaguesCallback: promptDialogExtraLeagues)
    );
  }

  void alertDialogExtraUsers() {
    showDialog(context: context, builder: (context) =>
        DialogTextExtraUsers(extraUsersCallback: promptDialogExtraUsers)
    );
  }
}
