import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../enums/FantasyLeagueInvitationStatus.dart';
import '../../enums/FantasyLeagueStatus.dart';
import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/context/AppContext.dart';
import '../dialog/DialogWizardLeagueLeaguesStep2.dart';
import '../row/FantasyLeaderBoardRow.dart';

class FantasyLeagueCard extends StatefulWidget {
  final FantasyLeague? fantasyLeague;
  final VoidCallback onOptOut;
  final void Function(String email) onInviteEmail;
  final List<ProductDetails> products;
  final Function topUpCallback;

  const FantasyLeagueCard({
    Key? key,
    required this.fantasyLeague,
    required this.onOptOut,
    required this.onInviteEmail,
    required this.products,
    required this.topUpCallback,
  }) : super(key: key);

  @override
  State<FantasyLeagueCard> createState() => _FantasyLeagueCardState();
}

class _FantasyLeagueCardState extends State<FantasyLeagueCard> {

  List<ProductDetails> products = [];

  late Function topUpCallback;

  @override
  void initState(){
    topUpCallback = widget.topUpCallback;
    products = widget.products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fantasyLeague = widget.fantasyLeague!;
    final duration = '${fantasyLeague.dtStart.toLocal().toString().split(' ')[0]} → '
        '${fantasyLeague.dtEnd.toLocal().toString().split(' ')[0]}';

    final leagues = fantasyLeague.selectedLeagueIds
        .map((id) => AppContext.allLeaguesMap[id])
        .whereType<League>()
        .toList();

    if (fantasyLeague.users.isNotEmpty && fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode) {
      fantasyLeague.users.sort((a, b) {
        return a.fantasyBalance.compareTo(b.fantasyBalance);
      });

    }

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fantasyLeague.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          duration,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 1, overflow: TextOverflow.ellipsis
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Initial credits: ${fantasyLeague.startingBalance.toStringAsFixed(0)} / ' ,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Icon(
                              fantasyLeague.allowTopUp ? Icons.attach_money : Icons.money_off,
                              color: fantasyLeague.allowTopUp ? Colors.green : Colors.red,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              fantasyLeague.allowTopUp ? 'Top-up allowed' : 'Top-up not allowed',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),

                        if (fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode && fantasyLeague.invitations.isNotEmpty)
                          Text('Invitations pending: ${fantasyLeague.invitations.where((i) => i.status == FantasyLeagueInvitationStatus.PENDING.statusCode).length}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey))

                      ],
                    ),
                  ),

                  if (AppContext.user.mongoUserId == fantasyLeague.creatorUserId)
                  ElevatedButton.icon(
                    onPressed: () => _showEditLeaguesDialog(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                  ),


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
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leagues.length > 10 ? 10 : leagues.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
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
                          style: const TextStyle(fontSize: 8),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (//fantasyLeague.invitations.isNotEmpty && //not empty due to admin user handled as invitation
                (fantasyLeague.status == FantasyLeagueStatus.PENDING.statusCode || fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode))
              Expanded(
                flex: 1,
                child: Center(
                  child: fantasyLeague.creatorUserId == AppContext.user.mongoUserId
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onPressed: () => _showInviteDialog(context),
                    child: const Text('Invite'),
                  )
                      : fantasyLeague.status == FantasyLeagueStatus.PENDING.statusCode ? const Text('⏳ Waiting for the league to start...') : const SizedBox(height:0),
                ),
              ),
            if (fantasyLeague.invitations.isNotEmpty &&
                fantasyLeague.status == FantasyLeagueStatus.PENDING.statusCode)
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: fantasyLeague.invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = fantasyLeague.invitations[index];
                    final statusText = invitation.mongoId == 'admin_invitation'
                        ? 'ADMIN'
                        : FantasyLeagueInvitationStatus.ofStatus(invitation.status).text;
                    final expirationStr =
                    (invitation.mongoId == 'admin_invitation' ||
                        FantasyLeagueInvitationStatus.COMPLETED.statusCode == invitation.status)
                        ? ''
                        : invitation.dtExpiration.toLocal().toString().split(' ')[0];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: invitation.mongoId == 'admin_invitation'
                                  ? Colors.black87
                                  : FantasyLeagueInvitationStatus.EXPIRED.statusCode == invitation.status
                                  ? Colors.red.shade300
                                  : FantasyLeagueInvitationStatus.COMPLETED.statusCode == invitation.status
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
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
                ),
              ),
            if (fantasyLeague.users.isNotEmpty &&
                fantasyLeague.status == FantasyLeagueStatus.RUNNING.statusCode)
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: fantasyLeague.users.length,
                  itemBuilder: (context, index) {
                    final user = fantasyLeague.users[index];
                    final int position = user.fantasyBalance.position;

                    return FantasyLeaderboardRow(user: user, position:  position > 0 ? position :  index + 1, products: products, topUpCallback: topUpCallback,);
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
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Invite by Email'),
            content: SingleChildScrollView(
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
                    setStateDialog(() => error = 'Invalid email address.');
                  } else if (widget.fantasyLeague!.invitedEmails.contains(email)) {
                    setStateDialog(() => error = 'This email has already been invited.');
                  } else {
                    Navigator.pop(context);
                    widget.onInviteEmail(email);
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
              ),
              child: const Text('Opt-Out', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onOptOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditLeaguesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DialogWizardLeagueLeaguesStep2(
        isEdit: true,
        leagueName: widget.fantasyLeague!.name,
        updateCallback: (a)=>{},
        initialSelectedLeagueIds: widget.fantasyLeague!.selectedLeagueIds,
      ),
    );
  }

}

