import 'package:flutter/material.dart';

class ProfileItemData {
  final String title;
  final IconData icon;

  ProfileItemData({
    required this.title,
    required this.icon,
  });
}

class ProfileItem extends StatelessWidget {
  final ProfileItemData data;

  const ProfileItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(data.icon, color: Colors.black54),
      title: Text(data.title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
