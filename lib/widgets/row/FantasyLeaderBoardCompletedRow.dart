import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';

import '../../models/User.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dialog/DialogTextWithButtons.dart';


class FantasyLeaderBoardCompletedRow extends StatefulWidget {
  final User user;
  final int position;
  const FantasyLeaderBoardCompletedRow({Key? key, required this.user,
    required this.position,}) : super(key: key);

  @override
  State<FantasyLeaderBoardCompletedRow> createState() => _FantasyLeaderBoardCompletedRowState();
}

class _FantasyLeaderBoardCompletedRowState extends State<FantasyLeaderBoardCompletedRow> {
  late User _user;
  late int position;
  @override
  void initState() {
    super.initState();
    _user = widget.user;
    position = widget.position;
  }

  @override
  void didUpdateWidget(covariant FantasyLeaderBoardCompletedRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user || oldWidget.position != widget.position) {
      setState(() {
        _user = widget.user;
        position = widget.position;
      });
    }
  }

  Widget _buildAnimatedDeltaIcon(int position) {
    // print('delta is ' + delta.toString());
    Icon icon;
    if (position == 1) {
      icon = const Icon(Icons.military_tech, color: Color(0xFFFFD700), size: 20);
    } else if (position == 2) {
      icon = const Icon(Icons.military_tech, color:Color(0xFFC0C0C0), size: 20);
    } else if (position == 3) {
      icon = const Icon(Icons.military_tech, color:Color(0xFFCD7F32), size: 20);
    }else{
      icon = const Icon(Icons.remove, color: Colors.grey, size: 16);
    }

    return icon;

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
                _buildAnimatedDeltaIcon(_user.fantasyBalance.position),
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
                Text(
                    'ROI%: ${_user.fantasyBalance.percentageROIText()}, Ret:${_user.fantasyBalance.amountROIText()}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
