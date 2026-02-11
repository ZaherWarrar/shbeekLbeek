import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';

class CustomTextFormFild extends StatelessWidget {
  const CustomTextFormFild({
    super.key,
    required this.hint,
    required this.controller,
    required this.valid,
    required this.lable,
    required this.iconData,
    this.scure,
    this.onTap,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final String hint, lable;
  final IconData iconData;
  final String? Function(String?) valid;
  final bool? scure;
  final Function()? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: scure == null || scure == false ? false : true,
      validator: valid,
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hoverColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: TextStyle(
          color: AppColor().titleColor,
          fontSize: 22,
        ),
        label: Text(lable),
        suffixIcon: IconButton(icon: Icon(iconData), onPressed: onTap),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: AppColor().titleColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: AppColor().titleColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: AppColor().primaryColor),
        ),
      ),
    );
  }
}
