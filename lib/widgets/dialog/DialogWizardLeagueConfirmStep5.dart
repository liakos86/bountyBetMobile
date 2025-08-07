import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/FantasyLeague.dart';
import '../../models/context/AppContext.dart';

class DialogWizardLeagueConfirmStep5 extends StatelessWidget {
  final FantasyLeague league;
  final VoidCallback onCreate;

  const DialogWizardLeagueConfirmStep5({
    required this.league,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      title: Center(
        child: Text(
          league.name,//"Review & Confirm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // content:
      content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected leagues
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: league.selectedLeagueIds.map((id) {
              final l = AppContext.allLeaguesMap[id]!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(l.logo ?? ''),
                    radius: 24,
                  ),
                  SizedBox(height: 6),
                  Text(
                    l.name,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 24),

        // Duration
        Center(
          child: Text(
            "${dateFormat.format(league.dtStart)} → ${dateFormat.format(league.dtEnd)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 24),

        // ✅ Starting Balance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Starting Balance:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("\$${league.startingBalance.toStringAsFixed(0)}"),
          ],
        ),
        SizedBox(height: 12),

        // ✅ Allow Top-Up
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top-Up Allowed:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(league.allowTopUp ? "Yes" : "No"),
          ],
        ),
      ],
    ),

      // Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     // 1. League name
      //     // Text(
      //     //   league.name,
      //     //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //     //   textAlign: TextAlign.center,
      //     // ),
      //     // SizedBox(height: 24),
      //
      //     // 2. Selected leagues
      //     Wrap(
      //       alignment: WrapAlignment.center,
      //       spacing: 16,
      //       runSpacing: 16,
      //       children: league.selectedLeagueIds.map((id) {
      //         final l = AppContext.allLeaguesMap[id]!;
      //         return Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             CircleAvatar(
      //               backgroundImage: NetworkImage(l.logo ?? ''),
      //               radius: 24,
      //             ),
      //             SizedBox(height: 6),
      //             Text(
      //               l.name,
      //               style: TextStyle(fontSize: 12),
      //               textAlign: TextAlign.center,
      //             ),
      //           ],
      //         );
      //       }).toList(),
      //     ),
      //     SizedBox(height: 24),
      //
      //     // 3. Duration
      //     Text(
      //       "${dateFormat.format(league.dtStart)} → ${dateFormat.format(league.dtEnd)}",
      //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      //       textAlign: TextAlign.center,
      //     ),
      //   ],
      // ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // cancel
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
            onCreate(); // callback to actually create league
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade500,
            foregroundColor: Colors.white,
          ),
          child: Text("Create"),
        ),
      ],
    );
  }
}
