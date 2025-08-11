import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/User.dart';

class FantasyLeaderboardRow extends StatefulWidget {
  final User user;
  final int position;

  const FantasyLeaderboardRow({Key? key, required this.user, required this.position}) : super(key: key);

  @override
  State<FantasyLeaderboardRow> createState() => _FantasyLeaderboardRowState();
}

class _FantasyLeaderboardRowState extends State<FantasyLeaderboardRow> {
  late User _user;
  late int position;
  // late UserFantasyLeagueBalance _fb;
  //final NumberFormat _formatter = NumberFormat.compactCurrency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    position = widget.position;
    // _fb = _user.fantasyBalance;
  }

  @override
  void didUpdateWidget(covariant FantasyLeaderboardRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user || oldWidget.position != widget.position) {
      setState(() {
        _user = widget.user;
        position = widget.position;
        // _fb = _user.fantasyBalance;
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
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
                  Text(_user.fantasyBalance.balance.round().toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),

            // Stats (wins/losses)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    '✅ Bets: ${_user.fantasyBalance.overallWonBets}, Preds: ${_user.fantasyBalance.overallWonPredictions}',
                    style: const TextStyle(fontSize: 12)),
                Text(
                    '❌ Bets: ${_user.fantasyBalance.overallLostBets}, Preds: ${_user.fantasyBalance.overallLostPredictions}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
