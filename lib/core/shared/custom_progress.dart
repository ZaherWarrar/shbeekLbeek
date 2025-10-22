import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:app/core/function/fontsize.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({super.key, required this.text, required this.progress});
  final double text;
  final double progress;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$text %",
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, fontSize: 20),
          ),
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 12.0,
            barRadius: Radius.circular(20),
            percent: progress,
            // ignore: deprecated_member_use
            linearStrokeCap: LinearStrokeCap.roundAll,
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            progressColor: Colors.blue,
            animation: true,
            animationDuration: 1500,
          ),
        ),
      ],
    );
  }
}
