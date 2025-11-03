
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserBet.dart';
import 'package:flutter_app/widgets/row/UserPredictionCardTilted.dart';

import '../models/UserPrediction.dart';
import '../models/context/AppContext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DialogSuccessfulBet extends StatelessWidget{

  UserBet newBet;


  DialogSuccessfulBet({required this.newBet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.all(8),
            backgroundColor: Colors.white,
            subtitle: Text(AppLocalizations.of(context)!.credits + newBet.betAmount.toStringAsFixed(2)),
            leading: Icon(Icons.sports, color: Colors.orangeAccent),
            title: Text(AppLocalizations.of(context)!.possible_earnings + newBet.toReturn().toStringAsFixed(2),
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
            children: newBet.predictions.map((item)=> _buildSelectedOddRow(item)).toList()
        ),

        TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(10),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade500)
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.close),
        )

      ],

    );
  }

  Widget _buildSelectedOddRow(UserPrediction bettingOdd) {
    return UserPredictionCardTilted(prediction: bettingOdd, callback: null, event: AppContext.findEvent(bettingOdd.eventId));
    // return UserBetPredictionRow(prediction: bettingOdd);
  }
}