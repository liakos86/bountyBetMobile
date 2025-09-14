import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../models/FantasyLeague.dart';
import '../../models/User.dart';


import '../row/FantasyLeaderBoardCompletedRow.dart';



class FantasyLeagueCompletedCard extends StatefulWidget {

  final FantasyLeague fantasyLeague;

  const FantasyLeagueCompletedCard({Key? key, required this.fantasyLeague}) : super(key: key);

  @override
  FantasyLeagueCompletedCardState createState() => FantasyLeagueCompletedCardState();


}

  class FantasyLeagueCompletedCardState extends State<FantasyLeagueCompletedCard>{

   late final FantasyLeague fantasyLeague;


   @override
  void initState() {
    fantasyLeague = widget.fantasyLeague;
    if (fantasyLeague.users.isNotEmpty) {
      fantasyLeague.users.sort((a, b) {
        return a.fantasyBalance.compareTo(b.fantasyBalance);
      });

    }

     super.initState();
  }


   @override
   Widget build(BuildContext context) {
     return Card(
       key: PageStorageKey<String>('fantasy_league_comp_${fantasyLeague.mongoId}'),
       color: Colors.grey.shade50,
       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [

             // Title row with leading icon and possible earnings
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         fantasyLeague.name,
                         style: const TextStyle(
                           fontSize: 16,
                           color: Colors.black87,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 4),
                       Text(
                         '${fantasyLeague.dtStart.toLocal().toString().split(' ')[0]} → '
                             '${fantasyLeague.dtEnd.toLocal().toString().split(' ')[0]}',
                         maxLines: 2,
                         style: Theme.of(context).textTheme.bodySmall,
                       ),
                     ],
                   ),
                 ),
               ],
             ),

             const SizedBox(height: 8),

             // Children predictions
             Column(
               children: fantasyLeague.users
                   .map((item) => _buildLeagueUserRow(item))
                   .toList(),
             ),
           ],
         ),
       ),
     );
   }


  Widget _buildLeagueUserRow(User user) {
    return FantasyLeaderBoardCompletedRow(user: user, position: user.fantasyBalance.finalPosition);
  }

}