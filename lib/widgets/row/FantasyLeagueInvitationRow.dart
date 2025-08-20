import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/FantasyLeague.dart';
import '../../models/FantasyLeagueInvitation.dart';
import '../../models/League.dart';
import '../../models/constants/Constants.dart';
import '../../models/context/AppContext.dart';
import '../../utils/client/HttpActionsClient.dart';


class FantasyLeagueInvitationRow extends StatefulWidget {
  final FantasyLeague league;
  // final Function onAccept;
  // final Function onDecline;

  const FantasyLeagueInvitationRow({
    Key? key,
    required this.league,
    // required this.onAccept,
    // required this.onDecline,
  }) : super(key: key);

  @override
  _FantasyLeagueInvitationRowState createState() =>
      _FantasyLeagueInvitationRowState();
}

class _FantasyLeagueInvitationRowState
    extends State<FantasyLeagueInvitationRow> {
  bool _accepted = false;
  bool _rejected = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    final league = widget.league;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
                Text(
                  league.name,

                  style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // if (league.isInvitation)
                //   Chip(
                //     label: Text("Invitation"),
                //     backgroundColor: Colors.orange.shade100,
                //   ),
              // ],
            // ),
            SizedBox(height: 8),
            Text(
              "Invited by: ${league.users.firstWhere((u) => u.mongoUserId == league.creatorUserId).username }",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              "Duration: ${dateFormat.format(league.dtStart)} - ${dateFormat.format(league.dtEnd)}",
              style: TextStyle(fontSize: 14),
            ),
            Divider(height: 24),
            Text(
              "Supported Leagues",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: league.selectedLeagueIds.map((id) {
                  final League? l = AppContext.allLeaguesMap[id];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(l?.logo ?? Constants.noImageUrl),
                        radius: 20,
                      ),
                      SizedBox(height: 4),
                      Text(
                        l?.name ?? 'league name',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Initial Balance:", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("\$${league.startingBalance.toStringAsFixed(0)}"),
              ],
            ),

            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top-Up Allowed:", style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Icon(
                      league.allowTopUp ? Icons.check_circle : Icons.cancel,
                      color: league.allowTopUp ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(league.allowTopUp ? "Yes" : "No"),
                  ],
                ),
              ],
            ),


            // Center(
          //     child:
          //     Wrap(
          //     alignment: WrapAlignment.center,
          //
          //     spacing: 12,
          //     runSpacing: 8,
          //     children: league.selectedLeagueIds.map((id) {
          //       final League? l = AppContext.allLeaguesMap[id];
          //       return Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           CircleAvatar(
          //             backgroundImage: NetworkImage(l?.logo ?? 'https://xscore.cc/resb/team/barcelona.png'),
          //             radius: 20,
          //           ),
          //           SizedBox(height: 4),
          //           Text(
          //             l?.name ?? 'league name',
          //             style: TextStyle(fontSize: 12),
          //           ),
          //         ],
          //       );
          //     }).toList(),
          //   )
          // ),

            // SizedBox(
            //   height: 55,
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: league.selectedLeagueIds.length,
            //     separatorBuilder: (context, _) => SizedBox(width: 12),
            //     itemBuilder: (context, index) {
            //       final League? l = AppContext.allLeaguesMap[league.selectedLeagueIds[index]] ;
            //       return Column(
            //         children: [
            //           CircleAvatar(
            //             backgroundImage: NetworkImage(l?.logo ?? 'https://xscore.cc/resb/team/barcelona.png'),
            //             radius: 20,
            //           ),
            //           SizedBox(height: 4),
            //           Text(
            //             l?.name ?? 'league name',
            //             style: TextStyle(fontSize: 12),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            if (!_accepted && !_rejected && !_error) ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (AppContext.user.fantasyLeagueMongoId == null) ?
                  TextButton(
                    onPressed: () {
                      _showDeclineConfirmation(league);
                      // widget.onDecline();
                      // setState(() => _accepted = true);
                    },
                    child: Text("Decline"),
                  ) : SizedBox(),

                  (AppContext.user.fantasyLeagueMongoId == null) ?
                  ElevatedButton(
                    onPressed: () {
                      _showAcceptConfirmation(league);
                      //widget.onAccept();
                      // setState(() => _accepted = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400, // Greenish hue
                      foregroundColor: Colors.white,          // Text color
                    ),
                    child: Text("Accept"),
                  ) : Text('You need to opt-out ${AppContext.fantasyLeague!.name} in order to accept'),
                ],
              ),
            ] else ...[
              SizedBox(height: 16),
              Center(
                child: Text(
                  _accepted ? "Invitation accept response sent" : _rejected ? "Invitation reject response sent" : 'Server error response',
                  style: TextStyle(color: _accepted ? Colors.green : Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  void _showAcceptConfirmation(FantasyLeague league) {
    showDialog(
      context: context, // or pass context directly
      builder: (context) {
        return AlertDialog(
          title: const Text('Accept Invitation'),
          content: const Text('Are you sure you want to accept this league invitation?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade300),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                acceptInvitation(league);

                // setState(() => _accepted = true);
                print("Accepted invitation");
              },
              child: const Text('Accept', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeclineConfirmation(FantasyLeague league) {
    showDialog(
      context: context, // or pass context directly
      builder: (context) {
        return AlertDialog(
          title: const Text('Decline Invitation'),
          content: const Text('Are you sure you want to decline this league invitation?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                FantasyLeagueInvitation fli = FantasyLeagueInvitation(email: AppContext.user.email);
                fli.mongoId = league.invitationMongoId;
                HttpActionsClient.rejectFantasyLeagueInvitation(fli);
                setState(() => _rejected = true);
                print("Declined invitation");
              },
              child: const Text('Decline', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void acceptInvitation(FantasyLeague league) async{
    FantasyLeagueInvitation fli = FantasyLeagueInvitation(email: AppContext.user.email);
    fli.mongoId = league.invitationMongoId;
    FantasyLeague fl = await HttpActionsClient.acceptFantasyLeagueInvitation(fli);
    if (Constants.defMongoId == fl.mongoId){
      setState(() => _error = true);
    }else{

      setState(() {_accepted = true; AppContext.fantasyLeague.copyFrom(fl);});
    }

  }
}
