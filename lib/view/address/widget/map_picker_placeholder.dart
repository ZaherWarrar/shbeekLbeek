import 'package:flutter/material.dart';

class MapPickerPlaceholder extends StatelessWidget {
  const MapPickerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          "الخريطة (تحديد الموقع)",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
