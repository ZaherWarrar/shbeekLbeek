import 'package:app/core/constant/app_color.dart';

import 'package:app/view/home_page/widget/category_slider.dart';

import 'package:app/core/shared/custom_slider.dart';


import 'package:app/core/shared/custom_slider.dart';

import 'package:app/view/home_page/widget/custom_home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomDeliveryAppBar(),

      body: ListView(
        children: [
          SizedBox(height: 10),
          //====================سلايدر الاعلانات ========
          SliderWidget(
            imageWidth: 310,
            height: 175, // يمكنك تعديل الارتفاع
            borderRadius: 20, // تعديل الحواف
            interval: Duration(seconds: 5), // المدة بين الصور
            onTapActions: [
              () => print("فتح المنتج الأول"),
              () => print("فتح المنتج الثاني"),
              () => print("فتح المنتج الثالث"),
              () => print("فتح المنتج الرابع"),
            ],
          ),
        ],
      ),
    );
  }
}
