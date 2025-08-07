import 'package:flutter/material.dart';

import '../../enums/FantasyLeagueInvitationStatus.dart';
import '../../enums/FantasyLeagueStatus.dart';
import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/context/AppContext.dart';
import 'package:collection/collection.dart';

import '../row/FantasyLeaderBoardRow.dart';



class FantasyLeagueCard extends StatelessWidget {
  final FantasyLeague? fantasyLeague;
  final VoidCallback onOptOut;
  final void Function(String email) onInviteEmail;

  const FantasyLeagueCard({
    Key? key,
    required this.fantasyLeague,
    required this.onOptOut,
    required this.onInviteEmail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // "${dateFormat.format(league.dtStart)} → ${dateFormat.format(league.dtEnd)}",
    final duration = '${fantasyLeague!.dtStart.toLocal().toString().split(' ')[0]} → '
        '${fantasyLeague!.dtEnd.toLocal().toString().split(' ')[0]}';

    final leagues = fantasyLeague?.selectedLeagueIds.map((id) => AppContext.allLeaguesMap[id]).whereType<League>().toList();


    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row with name, duration and opt-out

            Expanded(flex:1,
            child:

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fantasyLeague!.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        duration,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),


                    ],
                  ),
                ),
                // ElevatedButton(
                //   onPressed: onOptOut,
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: Colors.red.shade200,
                //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                //   ),
                //   child: const Text('Opt-out', style: TextStyle(fontSize:12)),
                // ),
                ElevatedButton(
                  onPressed: () => _showOptOutConfirmation(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  ),
                  child: const Text('Opt-out', style: TextStyle(fontSize: 12)),
                ),

              ],
            )
            ),

            //const SizedBox(height: 16),

            // Leagues row

            Expanded(flex:1,
            child:
            Center(
              child:

              GridView.builder(
                shrinkWrap: true, // 👈 Prevents unbounded height
                physics: const NeverScrollableScrollPhysics(), // 👈 Disables internal scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 👈 3 items per row
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1, // Adjust this to control item shape
                ),
                itemCount: leagues!.length,
                itemBuilder: (context, index) {
                  final league = leagues[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.network(league.logo ?? '', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        league.name,
                        style: const TextStyle(fontSize: 10, ),
                        textAlign: TextAlign.center,
                          maxLines:2
                      ),
                    ],
                  );
                },
              ),

            )
            ),

            // const SizedBox(height: 16),

            // Invite button
            if (fantasyLeague!.invitations.isNotEmpty && fantasyLeague?.status == FantasyLeagueStatus.PENDING.statusCode)

              Expanded(flex:1,
              child:

              Center(
              child:

              fantasyLeague?.creatorUserId == AppContext.user.mongoUserId ?
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onPressed: () => _showInviteDialog(context),
                child: const Text('Invite'),
              ) :

              Text('⏳ Waiting for the league to start...'),

            )
              ),

            // const SizedBox(height: 8),

            // Invitations list
            if (fantasyLeague!.invitations.isNotEmpty && fantasyLeague?.status == FantasyLeagueStatus.PENDING.statusCode)
              Expanded(flex:3,
              child:

             // SizedBox(
               // height: 200, // 👈 Adjust this height as needed
              //  child:
              ListView.builder(
                  itemCount: fantasyLeague!.invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = fantasyLeague!.invitations[index];
                    final statusText = 'admin_invitation'==invitation.mongoId ? 'ADMIN' :  FantasyLeagueInvitationStatus.ofStatus(invitation.status).text;
                    final expirationStr = ('admin_invitation'==invitation.mongoId || FantasyLeagueInvitationStatus.COMPLETED.statusCode == invitation.status) ? '' : invitation.dtExpiration.toLocal().toString().split(' ')[0];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                              'admin_invitation' == invitation.mongoId ?
                              Colors.black87
                              :
                              FantasyLeagueInvitationStatus.EXPIRED.statusCode == invitation.status ?
                              Colors.red.shade300
                                  :
                              FantasyLeagueInvitationStatus.COMPLETED.statusCode == invitation.status ?
                              Colors.green.shade300
                              :
                              Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              statusText,
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              invitation.email,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            expirationStr,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),



            if (fantasyLeague!.users.isNotEmpty && fantasyLeague?.status == FantasyLeagueStatus.RUNNING.statusCode)
              Expanded(flex:3,
                child:
              //SizedBox(
                //height: 200, // 👈 Adjust this height as needed
                //child:
                ListView.builder(
                  itemCount: fantasyLeague!.users.length,
                  itemBuilder: (context, index) {
                    final user = fantasyLeague!.users[index];

                    return FantasyLeaderboardRow(user: user);

                  },
                ),
              ),

          ],
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    final controller = TextEditingController();
    String? error;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Invite by Email'),
            content:
             SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: error,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),

            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     TextField(
            //       controller: controller,
            //       decoration: InputDecoration(
            //         labelText: 'Email',
            //         errorText: error,
            //       ),
            //       keyboardType: TextInputType.emailAddress,
            //     ),
            //   ],
            // ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = controller.text.trim();

                  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                  if (!emailRegex.hasMatch(email)) {
                    setState(() => error = 'Invalid email address.');
                  } else if (fantasyLeague!.invitedEmails.contains(email)) {
                    setState(() => error = 'This email has already been invited.');
                  } else {
                    Navigator.pop(context);
                    onInviteEmail(email);
                  }
                },
                child: const Text('Send Invite'),
              ),
            ],
          ),
        );
      },
    );
  }


  void _showOptOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Opt-Out'),
          content: const Text('Are you sure you want to opt out of this league? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
              ),
              child: const Text('Opt-Out', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
                onOptOut(); // perform the opt-out
              },
            ),
          ],
        );
      },
    );
  }



}
