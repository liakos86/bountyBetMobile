import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import '../../models/User.dart';
import '../../models/UserBet.dart';
import '../../models/UserPrediction.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dialog/DialogTextTopUp.dart';
import 'UserPastPredictionCompact.dart';


class FantasyLeaderboardRow extends StatefulWidget {
  final User user;
  final int position;
  final List<ProductDetails> products;
  final Function topUpCallback;

  const FantasyLeaderboardRow({Key? key, required this.user,
    required this.position,
    required this.topUpCallback,
    required this.products}) : super(key: key);

  @override
  State<FantasyLeaderboardRow> createState() => _FantasyLeaderboardRowState();
}

class _FantasyLeaderboardRowState extends State<FantasyLeaderboardRow> {
  late User _user;
  late int position;
  List<ProductDetails> products = [];
  late Function topUpCallback;
  UserPrediction? lastPrediction;

  @override
  void initState() {
    super.initState();
    topUpCallback = widget.topUpCallback;
    _user = widget.user;
    position = widget.position;
    products = widget.products;
    _prepareLastPrediction(); // 👈 add this
  }

  @override
  void didUpdateWidget(covariant FantasyLeaderboardRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user || oldWidget.position != widget.position) {
      setState(() {
        _user = widget.user;
        position = widget.position;
        _prepareLastPrediction(); // 👈 add this
      });
    }
  }

  Widget _buildAnimatedDeltaIcon(int delta) {
    // print('delta is ' + delta.toString());
    Icon icon;
    if (delta > 0) {
      icon = const Icon(Icons.arrow_upward, color: Colors.green, size: 16);
    } else if (delta < 0) {
      icon = const Icon(Icons.arrow_downward, color: Colors.red, size: 16);
    } else {
      icon = const Icon(Icons.remove, color: Colors.grey, size: 16);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 3000),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },// Must be a unique Key to trigger animation
      //key: ValueKey<int>(delta),
      child: Container(
        key: ValueKey<int>(delta), // Important: this triggers the switch
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool roundBalance = _user.fantasyBalance.balance  == _user.fantasyBalance.balance.roundToDouble();
    int digits = roundBalance ? 0 : 1;

    return Card(
      color: AppContext.user.mongoUserId == _user.mongoUserId ? Colors.blue[50] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child:

       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Row(
          children: [
            // Rank and movement
            Column(
              children: [
                Text(
                  // '#${_user.fantasyBalance.position}',
                  '#$position',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _buildAnimatedDeltaIcon(_user.fantasyBalance.positionDelta),
              ],
            ),
            const SizedBox(width: 16),

            // Username and balance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_user.username,
                      maxLines:1,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(_user.fantasyBalance.balance.toStringAsFixed(digits),
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),

            if (products.isNotEmpty && AppContext.user.mongoUserId == _user.mongoUserId && AppContext.fantasyLeague.allowTopUp  && AppContext.user.mongoUserId != Constants.defMongoId && AppContext.user.validated && AppContext.user.fantasyBalance.balance < 10 )
              ElevatedButton(
                key: UniqueKey(),
                onPressed: () {
                  alertDialogTopUp();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  minimumSize: const Size(0, 30), // Button size
                ),
                child:  Text(
                  AppLocalizations.of(context)!.topup_button_text,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),


            // Stats (wins/losses)
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Text(
            //         '✅ Bets: ${_user.fantasyBalance.overallWonBets}, Preds: ${_user.fantasyBalance.overallWonPredictions}',
            //         style: const TextStyle(fontSize: 12)),
            //     Text(
            //         '❌ Bets: ${_user.fantasyBalance.overallLostBets}, Preds: ${_user.fantasyBalance.overallLostPredictions}',
            //         style: const TextStyle(fontSize: 12)),
            //     Text(
            //         'ROI%: ${_user.fantasyBalance.percentageROIText()}, Ret:${_user.fantasyBalance.amountROIText()}',
            //         style: const TextStyle(fontSize: 12)),
            //   ],
            // ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        'Bets: ${_user.fantasyBalance.overallWonBets}, Preds: ${_user.fantasyBalance.overallWonPredictions}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        'Bets: ${_user.fantasyBalance.overallLostBets}, Preds: ${_user.fantasyBalance.overallLostPredictions}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                // Optionally, ROI Section
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, color: Colors.blueGrey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        'ROI: ${_user.fantasyBalance.percentageROIText()}, Ret:${_user.fantasyBalance.amountROIText()}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            )

          ],
        ),

          if (lastPrediction != null) const SizedBox(height: 6),
          if (lastPrediction != null)
            UserPastPredictionCompact(
              prediction: lastPrediction!,
            ),

        ]

       )

    ),
    );
  }

  void alertDialogTopUp() {
    showDialog(context: context, builder: (context) =>
        DialogTextTopUp(topUpCallback: topUpCallback)
    );
  }


  void _prepareLastPrediction() {
    lastPrediction = null;
    if (_user.userBets.isNotEmpty) {
      UserBet lastBet = _user.userBets[0];
      if (lastBet.predictions.isNotEmpty) {
        lastBet.predictions.sort(UserPrediction.compareByValueDescending);
        lastPrediction = lastBet.predictions[0];
      }
    }
  }

}
