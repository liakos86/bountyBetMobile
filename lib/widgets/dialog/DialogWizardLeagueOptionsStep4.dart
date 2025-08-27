import 'package:flutter/material.dart';

import '../../models/FantasyLeague.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../pages/MyFantasyLeaguesPage.dart';
import 'DialogWizardLeagueConfirmStep5.dart';
import '../../utils/client/HttpActionsClient.dart';

class DialogWizardLeagueOptionsStep4 extends StatefulWidget {
  final FantasyLeague league;
  final Function(FantasyLeague) updateCallback;

  const DialogWizardLeagueOptionsStep4({
    required this.league,
    required this.updateCallback
  });

  @override
  State<DialogWizardLeagueOptionsStep4> createState() => _DialogWizardLeagueOptionsStep4State();
}

class _DialogWizardLeagueOptionsStep4State extends State<DialogWizardLeagueOptionsStep4> {
  double _startingBalance = 1000;
  bool _allowTopUp = false;

  final List<double> _balances = [1000, 2000, 3000, 4000, 5000];

  void _onNext() {
    widget.league.startingBalance = _startingBalance;
    widget.league.allowTopUp = _allowTopUp;

    Navigator.of(context).pop(); // Close this step

    showDialog(
      context: context,
      builder: (_) => DialogWizardLeagueConfirmStep5(
        league: widget.league,
        onCreate: () {
          createLeague(widget.league);

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Step 4: League Settings"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Starting Balance", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: _balances.map((value) {
              return ChoiceChip(
                label: Text(value.toStringAsFixed(0)),
                selected: _startingBalance == value,
                onSelected: (_) => setState(() => _startingBalance = value),
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          CheckboxListTile(
            title: Text("Allow top-up during league"),
            value: _allowTopUp,
            onChanged: (val) => setState(() => _allowTopUp = val ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Back
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _onNext,
          child: const Text("Next"),
        ),
      ],
    );
  }

  void createLeague(FantasyLeague league) async{
    FantasyLeague league = await HttpActionsClient.createFantasyLeague(widget.league);
    if (league.mongoId != Constants.defMongoId) {
      widget.updateCallback.call(league);
    }
  }
}
