import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants/ColorConstants.dart';

class CustomTabIcon extends StatelessWidget {
  final String text;
  final bool isSelected;
  final double width;

  CustomTabIcon({
    required this.text,
    required this.isSelected,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      //color: isSelected ? const Color(ColorConstants.my_green) : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(ColorConstants.my_green) : Colors.grey[300],
        borderRadius: BorderRadius.circular(50.0),
      ),

      child: Align(alignment: Alignment.center, child: Text(text,maxLines: 1, style: TextStyle( color: isSelected? Colors.white : const Color(ColorConstants.my_dark_grey), fontSize: 12, fontStyle: FontStyle.italic,  fontWeight: isSelected? FontWeight.bold : FontWeight.normal),),)

    );
  }
}