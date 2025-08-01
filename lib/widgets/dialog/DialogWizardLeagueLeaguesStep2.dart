import 'package:flutter/material.dart';

import '../../models/context/AppContext.dart';
import 'DialogWizardLeagueDatesStep3.dart';

class DialogWizardLeagueLeaguesStep2 extends StatefulWidget {
  final String leagueName;

  const DialogWizardLeagueLeaguesStep2({required this.leagueName});

  @override
  State<DialogWizardLeagueLeaguesStep2> createState() => _LeagueSelectionDialogState();
}

class _LeagueSelectionDialogState extends State<DialogWizardLeagueLeaguesStep2> {
  final List<int> _selectedLeagueIds = [];

  void _onLeagueTap(int id) {
    if (_selectedLeagueIds.contains(id)) return;
    if (_selectedLeagueIds.length >= 3) return;

    setState(() {
      _selectedLeagueIds.add(id);
    });
  }

  void _onDeselect(int id) {
    setState(() {
      _selectedLeagueIds.remove(id);
    });
  }

  void _onNext() {
    if (_selectedLeagueIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one league.")),
      );
      return;
    }

    Navigator.of(context).pop(); // Close this step
    _showNextStep(context, widget.leagueName, _selectedLeagueIds);
  }

  @override
  Widget build(BuildContext context) {
    final allLeagues = AppContext.allLeaguesMap;

    return AlertDialog(
      title: Text("Step 2: Select Leagues"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedLeagueIds.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Selected:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _selectedLeagueIds.map((id) {
                final league = allLeagues[id]!;
                return InputChip(
                  avatar: CircleAvatar(backgroundImage: NetworkImage(league.logo ?? '')),
                  label: Text(league.name),
                  onDeleted: () => _onDeselect(id),
                );
              }).toList(),
            ),
            Divider(height: 20),
          ],
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: allLeagues.entries.map((entry) {
                final league = entry.value;
                final isSelected = _selectedLeagueIds.contains(entry.key);
                return ListTile(
                  onTap: isSelected ? null : () => _onLeagueTap(entry.key),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(league.logo ?? ''),
                  ),
                  title: Text(league.name),
                  tileColor: isSelected ? Colors.grey.shade200 : null,
                  trailing: isSelected ? Icon(Icons.check, color: Colors.grey) : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _onNext,
          child: const Text("Next"),
        ),
      ],
    );
  }

  void _showNextStep(BuildContext context, String name, List<int> selectedLeagueIds) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogWizardLeagueDatesStep3(
        leagueName: name,
        selectedLeagueIds: selectedLeagueIds,
      ),
    );
  }

}
