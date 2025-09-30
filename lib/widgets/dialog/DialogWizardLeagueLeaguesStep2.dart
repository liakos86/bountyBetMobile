import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';

import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/constants/Constants.dart';
import '../../models/constants/PurchaseConstants.dart';
import '../../models/context/AppContext.dart';
import '../../utils/client/HttpActionsClient.dart';
import 'DialogWizardLeagueDatesStep3.dart';

class DialogWizardLeagueLeaguesStep2 extends StatefulWidget {
  final String leagueName;

  final Function(FantasyLeague) updateCallback;

  final Function() alertDialogExtraLeagues;

  final List<int> initialSelectedLeagueIds;
  final bool isEdit; // new flag
  final List<ProductDetails> products;

  const DialogWizardLeagueLeaguesStep2({
    required this.leagueName,
    required this.updateCallback,
    this.initialSelectedLeagueIds = const [],
    this.isEdit = false,
    required this.products,
    required this.alertDialogExtraLeagues,
  });


  @override
  State<DialogWizardLeagueLeaguesStep2> createState() => _LeagueSelectionDialogState();
}

class _LeagueSelectionDialogState extends State<DialogWizardLeagueLeaguesStep2> {
  late List<int> _selectedLeagueIds;

  late int maxLeagues;

  // Function(FantasyLeague) updateCallback = (a)=>{};

  @override
  void initState() {
    super.initState();
    _selectedLeagueIds = List<int>.from(widget.initialSelectedLeagueIds);
    maxLeagues = 3;

    bool hasExtraLeagues = AppContext.user.purchases.any((purchase) => purchase.productId == PurchaseConstants.extra_leagues);

    if (hasExtraLeagues) {
      maxLeagues = 10;
    }

  }


  void _onLeagueTap(int id) {
    if (_selectedLeagueIds.contains(id)) return;
    if (_selectedLeagueIds.length >= maxLeagues) {

        Fluttertoast.showToast(
          msg: "Unlock more leagues! Max leagues are $maxLeagues",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      return;
    }

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
      Fluttertoast.showToast(
        msg: "Please select at least one league.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      return;
    }

    if (_selectedLeagueIds.length > maxLeagues) {
      Fluttertoast.showToast(
        msg: "Max leagues are $maxLeagues",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
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
      title:
      //Column(
        //mainAxisSize: MainAxisSize.max,
        //children: [
          const Text("Step 2: Select Leagues", style: TextStyle(fontSize: 22)),
          // const SizedBox(width: 8),

        // ],
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          if (maxLeagues < 10)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.alertDialogExtraLeagues.call();
                },
                icon: const Icon(Icons.lock_open),
                label: const Text("Unlock leagues"),
              ),
            ),

          if (maxLeagues == 10)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  //nothing
                },
                icon: const Icon(Icons.lock),
                label: const Text("Pro leagues enabled"),
              ),
            ),

          if (_selectedLeagueIds.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Selected:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 3.5, // Adjust as needed
              children: _selectedLeagueIds.map((id) {
                final league = allLeaguesMap[id]!;
                return InputChip(
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(league.logo ?? ''),
                  ),
                  label: Text(
                    league.name,
                    overflow: TextOverflow.ellipsis, // Truncate long names
                  ),
                  onDeleted: () => _onDeselect(id),
                );
              }).toList(),
            ),

            // Wrap(
            //   spacing: 4,
            //   children: _selectedLeagueIds.map((id) {
            //     final league = allLeaguesMap[id]!;
            //     return InputChip(
            //       avatar: CircleAvatar(backgroundImage: NetworkImage(league.logo ?? '')),
            //       label: Text(league.name),
            //       onDeleted: () => _onDeselect(id),
            //     );
            //   }).toList(),
            // ),
            const Divider(height: 10),
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
