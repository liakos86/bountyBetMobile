import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/FantasyLeague.dart';
import '../../models/League.dart';
import '../../models/context/AppContext.dart';


class FantasyLeagueInvitationRow extends StatefulWidget {
  final FantasyLeague league;
  final Function onAccept;
  final Function onDecline;

  const FantasyLeagueInvitationRow({
    Key? key,
    required this.league,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  _FantasyLeagueInvitationRowState createState() =>
      _FantasyLeagueInvitationRowState();
}

class _FantasyLeagueInvitationRowState
    extends State<FantasyLeagueInvitationRow> {
  bool _responded = false;

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
              "Invited by: ${league.creatorUserId}",
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
              child:
              Wrap(
              alignment: WrapAlignment.center,

              spacing: 12,
              runSpacing: 8,
              children: league.selectedLeagueIds.map((id) {
                final League? l = AppContext.allLeaguesMap[id];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(l?.logo ?? 'https://xscore.cc/resb/team/barcelona.png'),
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
            )
          ),

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
            if (!_responded) ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (AppContext.user.fantasyLeagueMongoId == null) ?
                  TextButton(
                    onPressed: () {
                      widget.onDecline();
                      setState(() => _responded = true);
                    },
                    child: Text("Decline"),
                  ) : SizedBox(),

                  (AppContext.user.fantasyLeagueMongoId == null) ?
                  ElevatedButton(
                    onPressed: () {
                      widget.onAccept();
                      setState(() => _responded = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400, // Greenish hue
                      foregroundColor: Colors.white,          // Text color
                    ),
                    child: Text("Accept"),
                  ) : Text('You need to opt-out in order to accept'),
                ],
              ),
            ] else ...[
              SizedBox(height: 16),
              Center(
                child: Text(
                  "Response Sent",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
