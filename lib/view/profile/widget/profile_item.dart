import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileItemData {
  final String title;
  final IconData icon;
  final String? route;

  ProfileItemData({required this.title, required this.icon, this.route});
}

class ProfileItem extends StatelessWidget {
  final ProfileItemData data;

  const ProfileItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(data.icon, color: Colors.orange),

      title: Text(data.title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        if (data.route != null) {
          Get.toNamed(data.route!);
        }
      },
    );
  }
}
