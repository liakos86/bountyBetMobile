import 'package:flutter/material.dart';

import '../../enums/FantasyLeagueInvitationStatus.dart';
import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/context/AppContext.dart';
import 'package:collection/collection.dart';



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
    final duration = '${fantasyLeague!.dtStart.toLocal().toString().split(' ')[0]} - '
        '${fantasyLeague!.dtEnd.toLocal().toString().split(' ')[0]}';

    final leagues = fantasyLeague?.selectedLeagueIds.map((id) => AppContext.allLeaguesMap[id]).whereType<League>().toList();


    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row with name, duration and opt-out
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

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.verified_user, size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            'Admin: ${_getAdminEmail()}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onOptOut,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text('Opt-out'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Leagues row
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
                        height: 40,
                        width: 40,
                        child: Image.network(league.logo ?? '', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        league.name,
                        style: const TextStyle(fontSize: 12, ),
                        textAlign: TextAlign.center,
                          maxLines:2
                      ),
                    ],
                  );
                },
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: leagues!.map((league) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 12),
              //       child: Column(
              //         children: [
              //           SizedBox(
              //             height: 40,
              //             width: 40,
              //             child: Image.network(league.logo ?? '', fit: BoxFit.cover),
              //           ),
              //           const SizedBox(height: 4),
              //           Text(
              //             league.name,
              //             style: const TextStyle(fontSize: 12),
              //           ),
              //         ],
              //       ),
              //     );
              //   }).toList(),
              // ),
            ),

            // const SizedBox(height: 16),

            // Invite button
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

              Text('Waiting for league to start'),

            ),

            const SizedBox(height: 8),

            // Invitations list
            if (fantasyLeague!.invitations.isNotEmpty)
              SizedBox(
                height: 200, // 👈 Adjust this height as needed
                child: ListView.builder(
                  itemCount: fantasyLeague!.invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = fantasyLeague!.invitations[index];
                    final statusText = FantasyLeagueInvitationStatus.ofStatus(invitation.status).text;
                    final expirationStr = invitation.dtExpiration.toLocal().toString().split(' ')[0];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: FantasyLeagueInvitationStatus.EXPIRED.statusCode == invitation.status ?
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
                              style: const TextStyle(fontSize: 12),
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
                ),
              ),



            // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     ...fantasyLeague!.invitations.map((invitation) {
              //       final statusText = FantasyLeagueInvitationStatus.ofStatus(invitation.status).text;
              //       final expirationStr = invitation.dtExpiration.toLocal().toString().split(' ')[0];
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 4.0),
              //         child: Row(
              //           children: [
              //             Container(
              //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //               decoration: BoxDecoration(
              //                 color: Colors.grey.shade300,
              //                 borderRadius: BorderRadius.circular(4),
              //               ),
              //               child: Text(
              //                 statusText,
              //                 style: const TextStyle(fontSize: 12),
              //               ),
              //             ),
              //             const SizedBox(width: 12),
              //             Expanded(
              //               child: Text(
              //                 invitation.email,
              //                 style: const TextStyle(fontSize: 14),
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //             ),
              //             const SizedBox(width: 12),
              //             Text(
              //               expirationStr,
              //               style: const TextStyle(fontSize: 12, color: Colors.grey),
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //
              //     ).toList(),
              //   ],
              // ),
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

  String _getAdminEmail() {
    final adminUser = fantasyLeague?.users
        .firstWhereOrNull((u) => u.mongoUserId == fantasyLeague!.creatorUserId);

    return adminUser?.email ?? 'Unknown';
  }


}
