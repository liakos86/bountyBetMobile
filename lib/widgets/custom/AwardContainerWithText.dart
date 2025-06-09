import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/UserMonthlyBalance.dart';
import '../../utils/BetUtils.dart';

class AwardContainerWithText extends StatelessWidget{

  final UserMonthlyBalance award;

  final double fontSize;

  AwardContainerWithText({required this.award, required this.fontSize});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack the icon and number together
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 30,
                color: Colors.amber[800 - ( (award.position - 1) * 100)],
              ),
              Text(
                award.position.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            BetUtils.getLocalizedMonthString(context, award.month, award.year),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );


  }

}