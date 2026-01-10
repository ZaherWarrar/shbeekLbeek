import 'package:flutter/material.dart';

class OrderTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isExpired;

  const OrderTimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.isExpired,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: isExpired ? Colors.grey.shade200 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired ? Colors.grey.shade400 : Colors.orange.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            size: isSmallScreen ? 40 : 50,
            color: isExpired ? Colors.grey : Colors.orange,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            isExpired ? "انتهى وقت الإلغاء" : "الوقت المتبقي للإلغاء",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            _formatTime(remainingSeconds),
            style: TextStyle(
              fontSize: isSmallScreen ? 32 : 40,
              fontWeight: FontWeight.bold,
              color: isExpired ? Colors.grey : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
