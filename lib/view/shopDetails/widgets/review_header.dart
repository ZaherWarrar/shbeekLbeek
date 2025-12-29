import 'package:app/main.dart';
import 'package:flutter/material.dart';

class ReviewHeader  extends StatelessWidget {
  const ReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "التقييمات والتعليقات",
                        style: TextStyle(
                          fontSize: h * 0.022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "عرض الكل",
                        style: TextStyle(
                          fontSize: h * 0.018,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                );
  }
}