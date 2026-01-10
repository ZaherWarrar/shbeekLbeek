import 'package:flutter/material.dart';
import 'profile_item.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileItemData> items;

  const ProfileSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.orange,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: items.map((e) => ProfileItem(data: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
