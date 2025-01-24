import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';
import 'package:flutter_app/widgets/DialogLogin.dart';

import 'CustomTabIcon.dart';
import 'DialogRegister.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogTabbedLoginOrRegister extends StatefulWidget {

  late final Function registerCallback;

  late final Function loginCallback;

  DialogTabbedLoginOrRegister({
    required this.registerCallback,
    required this.loginCallback,
    //setName('Today\'s Odds')

  });

  @override
  State<StatefulWidget> createState() => DialogTabbedLoginOrRegisterState(registerCallback: registerCallback, loginCallback: loginCallback);

}

class DialogTabbedLoginOrRegisterState extends State<DialogTabbedLoginOrRegister>  with SingleTickerProviderStateMixin{

  DialogTabbedLoginOrRegisterState({
    required this.registerCallback,
    required this.loginCallback,
    //setName('Today\'s Odds')

  });

  late  Function registerCallback;

  late  Function loginCallback;

  late TabController _tabController;


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loginCallback = widget.loginCallback;
    registerCallback = widget.registerCallback;

    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    const int items = 2;
    double width = MediaQuery.of(context).size.width;
    const double labelPadding = 4;
    double labelWidth = (width / items ) - (labelPadding*items);

    return

      AlertDialog(
        // title: const Text('Welcome'),
          backgroundColor: const Color(ColorConstants.my_dark_grey),
          // titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          insetPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(2.0),
          buttonPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          elevation: 20,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.only(topLeft:
              Radius.circular(10.0), topRight: Radius.circular(10.0))),
          content:

          Builder(
          builder: (context) {
      // Get available height and width of the build area of this widget. Make a choice depending on the size.
      var height = MediaQuery
          .of(context)
          .size
          .height * (2 / 3);
      var width = MediaQuery
          .of(context)
          .size
          .width;
      return SizedBox(width: width, height: height,
      child:



      DefaultTabController(
        length: 2,
        child:

      Scaffold(

          appBar: AppBar(
            backgroundColor: const Color(ColorConstants.my_dark_grey),
            toolbarHeight: 5,
            bottom:

              TabBar(

                labelPadding: const EdgeInsets.symmetric(horizontal: labelPadding),
                indicator: const BoxDecoration(),
                controller: _tabController,
                tabAlignment: TabAlignment.center,


                isScrollable: true,


              tabs: [
                CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.login, isSelected: _tabController.index == 0,),
                CustomTabIcon(width: labelWidth, text: AppLocalizations.of(context)!.register, isSelected: _tabController.index == 1,),
              ],

              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              }
            ),


      ),

          body: TabBarView(
            controller: _tabController,
            children: [
              DialogLogin(callback: loginCallback),

              DialogRegister(callback: registerCallback),

            ],),


      ),
    )


      );
          }
          ));
  }


}