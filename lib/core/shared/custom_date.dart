import 'package:flutter/material.dart';
import 'package:app/core/function/fontsize.dart';

class CustomDate extends StatelessWidget {
  const CustomDate({super.key, required this.text, required this.date});
  final String date , text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
         text,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: getResponsiveFontSize(context, fontSize: 20),
          ),
        ),
        SizedBox(width: 5),
        Text(
          date,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: getResponsiveFontSize(context, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
