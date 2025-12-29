import 'package:flutter/material.dart';

class ReviewItemWidget extends StatelessWidget {
  final String name;
  final String time;
  final int rating;
  final String comment;

  const ReviewItemWidget({
    super.key,
    required this.name,
    required this.time,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: h * 0.03,
                backgroundColor: Colors.orange.withOpacity(0.3),
                child: const Icon(Icons.person, color: Colors.white),
              ),

              SizedBox(width: w * 0.03),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: h * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: h * 0.015,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.01),

          /// النجوم
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: h * 0.028,
                color: index < rating ? Colors.orange : Colors.grey[300],
              );
            }),
          ),

          SizedBox(height: h * 0.01),

          /// التعليق
          Text(
            comment,
            style: TextStyle(fontSize: h * 0.017),
          ),
        ],
      ),
    );
  }
}
