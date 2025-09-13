import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../models/FantasyLeague.dart';
import '../../models/User.dart';
import '../../models/constants/ColorConstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../row/FantasyLeaderBoardRow.dart';

class DialogFantasyLeagueWinner extends StatefulWidget {
  final FantasyLeague league;
  final Function confirmWinnerCallback;

  const DialogFantasyLeagueWinner({
    Key? key,
    required this.league,
    required this.confirmWinnerCallback,
  }) : super(key: key);

  @override
  State<DialogFantasyLeagueWinner> createState() => _DialogFantasyLeagueWinnerState();
}

class _DialogFantasyLeagueWinnerState extends State<DialogFantasyLeagueWinner>
    with SingleTickerProviderStateMixin {
  ParticleOptions? particles;
  late FantasyLeague league;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    league = widget.league;
    league.users.sort();
  }

  @override
  Widget build(BuildContext context) {
    particles = ParticleOptions(
      image: Image.asset('assets/images/money-bag-100.png'),
      baseColor: Colors.amber,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 20,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );

    User myUserInWinners = league.users.firstWhere(
          (element) => element.mongoUserId == AppContext.user.mongoUserId,
      orElse: () => User.defUser(),
    );

    return AlertDialog(
      title: Text(
             '🎉 🎉 🎉 ${AppLocalizations.of(context)!.congrats_text_fantasy( myUserInWinners.fantasyBalance.balance, widget.league.name, myUserInWinners.fantasyBalance.finalPosition,)} 🎊 🎊 🎊',
        style: const TextStyle(fontSize: 16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 12.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content:
    SizedBox(
    height: 400,
      child:

      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                key: const PageStorageKey<String>('leaderFinalFantasyLeague'),
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                itemCount: league.users.length,
                itemBuilder: (context, index) {
                  User user = league.users[index];
                  return _buildLeaderUserRowPlain(user, 'flWinner$index${user.mongoUserId}');
                },
              ),
            ),

            // Centered checkbox
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.dont_show_again_checkbox_label, // Add this to localization
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Button
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.confirmWinnerCallback.call(_isChecked, league.mongoId);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(ColorConstants.my_dark_grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildLeaderUserRowPlain(User user, String key) {
    return FantasyLeaderboardRow(user: user, position: user.fantasyBalance.finalPosition, products: const <ProductDetails>[], topUpCallback: ()=>{},);
  }
}


