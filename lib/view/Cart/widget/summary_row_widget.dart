import 'package:flutter/material.dart';

class SummaryRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const SummaryRowWidget(
    this.title,
    this.value, {
    super.key,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
