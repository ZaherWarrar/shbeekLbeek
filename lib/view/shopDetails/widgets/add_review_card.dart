import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class AddReviewCardWidget extends StatelessWidget {
  const AddReviewCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColor().backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor().titleColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// العنوان
          Text(
            "أضف تقييمك",
            style: TextStyle(fontSize: h * 0.02, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: h * 0.015),

          /// النجوم
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: h * 0.035,
                color: index >= 3 ? AppColor().descriptionColor : AppColor().primaryColor,
              );
            }),
          ),

          SizedBox(height: h * 0.015),

          /// حقل الإدخال
          Container(
            height: h * 0.12,
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor().descriptionColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: "اكتب ملاحظاتك هنا...",
                hintStyle: TextStyle(fontSize: h * 0.017),
                border: InputBorder.none,
              ),
            ),
          ),

          SizedBox(height: h * 0.02),

          /// زر الإرسال
          SizedBox(
            width: double.infinity,
            height: h * 0.065,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor().primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {},
              child: Text(
                "إرسال التقييم",
                style: TextStyle(
                  fontSize: h * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
