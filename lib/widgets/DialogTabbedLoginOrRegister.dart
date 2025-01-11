import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/DialogLogin.dart';

import 'DialogRegister.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogTabbedLoginOrRegister extends StatelessWidget {

  late final Function registerCallback;

  late final Function loginCallback;

  DialogTabbedLoginOrRegister({
    required this.registerCallback,
    required this.loginCallback,
    //setName('Today\'s Odds')

  }) ;


  @override
  Widget build(BuildContext context) {

    return

      AlertDialog(
        // title: const Text('Welcome'),
          backgroundColor: Colors.blueAccent,
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
      initialIndex: 1,
      length: 2,

      child:

      Scaffold(
        // resizeToAvoidBottomInset: false,

          appBar: AppBar(
            toolbarHeight: 0,
            bottom:

              TabBar(

                isScrollable: false,
                indicatorColor: Colors.red,
                indicatorWeight: 2,
                unselectedLabelColor: Colors.grey.withOpacity(0.5),

              tabs: [
                Tab(text: AppLocalizations.of(context)!.login),
                Tab(text: AppLocalizations.of(context)!.register),

              ],
            ),


      ),

          body: TabBarView(
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