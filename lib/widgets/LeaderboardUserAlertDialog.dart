import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/ParentPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../models/User.dart';
import '../models/constants/Constants.dart';

class LeaderboardUserAlertDialog extends StatelessWidget {

  final User user;

  LeaderboardUserAlertDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return

      Container(
        color: Colors.white,

    child:
      Column(

    children:[

          Expanded( flex: 1, child:  Container(color: Colors.cyan[50], child:Row(mainAxisAlignment: MainAxisAlignment.center, children:[  Text(user.username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)]))),

          const Expanded( flex: 2, child:  Row(mainAxisAlignment: MainAxisAlignment.center, children:[  Icon(Icons.person_3_rounded, size: 64,)])),

          Expanded( flex: 3, child: Column(
            children: [
              Text('${user.username}:${user.balance}') ,
              Text(AppLocalizations.of(context)!.monthlybetswon + user.betSlipsMonthlyText()) ,
              Text(AppLocalizations.of(context)!.monthlypredswon + user.betPredictionsMonthlyText()) ,

            ],)),


      (ParentPageState.user.mongoUserId == Constants.defMongoUserId ||  ParentPageState.user.mongoUserId != user.mongoUserId) ?

          Expanded( flex: 1, child: Container(width: double.infinity, color: Colors.red, child: TextButton(

            style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(10),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
            ),
            onPressed: () {
            //
            },
            child: Text(AppLocalizations.of(context)!.buypreds +  user.username),
            ))
          )

              :

              const SizedBox()
        ]
      )

    );
  }

}