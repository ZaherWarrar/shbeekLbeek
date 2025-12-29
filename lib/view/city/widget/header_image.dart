import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class HeaderImage extends StatelessWidget {
  final String imageUrl;
  const HeaderImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor().primaryColor,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
