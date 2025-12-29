// lib/widgets/place_card.dart
import 'package:app/core/constant/app_color.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class CityWidget extends StatelessWidget {
  final int cityId;
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;
  final double height;

  const CityWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
    this.height = 150, required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: w * 0.9,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColor().primaryColor,
                blurRadius: 4,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(title, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
