import 'package:flutter/material.dart';

import '../../models/FantasyLeague.dart';
import '../../models/constants/Constants.dart';
import 'DialogWizardLeagueConfirmStep5.dart';
import '../../utils/client/HttpActionsClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
      title: Text(AppLocalizations.of(context)!.step4_league_settings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.initial_credits, style: TextStyle(fontWeight: FontWeight.bold)),
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

          SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.topup_explained,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ),
            ],
          ),

          SizedBox(height: 4),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.allow_addon),
            value: _allowTopUp,
            onChanged: (val) => setState(() => _allowTopUp = val ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Back
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _onNext,
          child: Text(AppLocalizations.of(context)!.next),
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
