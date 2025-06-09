import 'package:flutter/material.dart';

import '../../models/UserMonthlyBalance.dart';


class LeaderBoardUserPlainRow extends StatelessWidget {
  final UserMonthlyBalance balance;
  final String username;

  const LeaderBoardUserPlainRow({
    Key? key,
    required this.balance,
    required this.username,
  }) : super(key: key);

  // Choose an icon based on position
  Widget _getPositionIcon(int position) {
    if (position == 1) {
      return const Icon(Icons.emoji_events, color: Colors.amber);
    } else if (position == 2) {
      return const Icon(Icons.emoji_events, color: Colors.grey);
    } else if (position == 3) {
      return const Icon(Icons.emoji_events, color: Colors.brown);
    } else if (position <= 5) {
      return const Icon(Icons.star, color: Colors.blueAccent);
    } else {
      return const Icon(Icons.person, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return

      Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Row(
        children: [
          // Position + Icon

          Expanded(flex:1, child:

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getPositionIcon(balance.position),
              const SizedBox(width: 4),
              Text('#${balance.position}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
          ),

          const SizedBox(width: 8),

        Expanded(flex:3, child:
          // Username

            Text(
              username,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),

        ),

        Expanded(flex:2, child:
          // Balance + Icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.attach_money, color: Colors.green),
              const SizedBox(width: 2),
              Text(
                balance.balanceLeaderBoard.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ),
        ],
      ),
    );
  }
}
