
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/constants/ColorConstants.dart';

class NoGames extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Align(alignment: Alignment.center,  child: Column(
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
          AppLocalizations.of(context)!.no_live_games,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(ColorConstants.my_dark_grey),
          ),
        ),
      ],
    )
    );
  }

}
