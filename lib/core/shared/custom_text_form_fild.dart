import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/constant/app_color.dart';

class CustomTextFormFild extends StatelessWidget {
  const CustomTextFormFild({
    super.key,
    required this.hint,
    required this.controller,
    required this.lable,
    required this.iconData,
    this.valid,
    this.scure = false,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint, lable;
  final IconData iconData;
  final String? Function(String?)? valid;
  final bool scure;
  final Function()? onTap;
  final bool readOnly;
  final void Function(String?)? onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: scure,
      validator: valid,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.black),
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
        errorText: errorText,
        suffixIcon: IconButton(
          icon: Icon(iconData, color: AppColor().titleColor),
          onPressed: onTap,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        counterText: '',
      ),
    );
  }
}