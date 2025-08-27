import 'package:flutter/material.dart';

import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../utils/client/HttpActionsClient.dart';
import 'DialogWizardLeagueDatesStep3.dart';

class DialogWizardLeagueLeaguesStep2 extends StatefulWidget {
  final String leagueName;

  final Function(FantasyLeague) updateCallback;

  final List<int> initialSelectedLeagueIds;
  final bool isEdit; // new flag

  const DialogWizardLeagueLeaguesStep2({
    required this.leagueName,
    required this.updateCallback,
    this.initialSelectedLeagueIds = const [],
    this.isEdit = false,
  });


  @override
  State<DialogWizardLeagueLeaguesStep2> createState() => _LeagueSelectionDialogState();
}

class _LeagueSelectionDialogState extends State<DialogWizardLeagueLeaguesStep2> {
  late List<int> _selectedLeagueIds;

  // Function(FantasyLeague) updateCallback = (a)=>{};

  @override
  void initState() {
    super.initState();
    _selectedLeagueIds = List<int>.from(widget.initialSelectedLeagueIds);
    // updateCallback = widget.updateCallback;
  }


  void _onLeagueTap(int id) {
    if (_selectedLeagueIds.contains(id)) return;
    if (_selectedLeagueIds.length >= 10) return;

    setState(() {
      _selectedLeagueIds.add(id);
    });
  }

  void _onDeselect(int id) {
    setState(() {
      _selectedLeagueIds.remove(id);
    });
  }

  Future<void> _onNext() async{
    if (_selectedLeagueIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one league.")),
      );
      return;
    }



    if (!widget.isEdit) {
      Navigator.of(context).pop(); // Close this step
      _showNextStep(context, widget.leagueName, _selectedLeagueIds);
    }else{
      Navigator.of(context).pop();
      await editLeague();
      // if (mounted) {
      //   Navigator.of(context).pop(); // Close this step
      // }
    }




  }

  @override
  Widget build(BuildContext context) {
    final allLeaguesMap = AppContext.allLeaguesMap;

    final List<League> allLeagues = List.of(allLeaguesMap.values);
    allLeagues.sort();


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
                final league = allLeaguesMap[id]!;
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
              children: allLeagues.map((entry) {
                final league = entry;
                final isSelected = _selectedLeagueIds.contains(league.league_id);
                return ListTile(
                  onTap: isSelected ? null : () => _onLeagueTap(league.league_id),
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
          child: Text( (widget.isEdit) ? "Save" : "Next"),
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
        updateCallback: widget.updateCallback
      ),
    );
  }

  Future<void>  editLeague () async{
    FantasyLeague fCopy = AppContext.fantasyLeague.clone();
    fCopy.selectedLeagueIds = _selectedLeagueIds;
    fCopy = await HttpActionsClient.editFantasyLeague(fCopy);
    if (fCopy.mongoId != Constants.defMongoId){
      await widget.updateCallback.call(fCopy);
    }
  }

}
