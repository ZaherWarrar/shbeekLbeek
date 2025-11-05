import 'package:app/core/constant/app_images.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/main.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class CategorySlider extends StatelessWidget {
  CategorySlider({super.key});
  List data = [
    {"image": Assets.imagesCategory1, "title": "مطاعم"},
    {"image": Assets.imagesCategory2, "title": "بقالة"},
    {"image": Assets.imagesCategory3, "title": "صيدلية"},
    {"image": Assets.imagesCategory4, "title": "قهوة"},
    {"image": Assets.imagesCategory1, "title": "مطاعم"},
    {"image": Assets.imagesCategory2, "title": "بقالة"},
    {"image": Assets.imagesCategory3, "title": "صيدلية"},
    {"image": Assets.imagesCategory4, "title": "قهوة"},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Text(
                "الأصناف",
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, fontSize: 35),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: FittedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(data[index]["image"]),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              data[index]["title"],
                              style: TextStyle(
                                fontSize: getResponsiveFontSize(
                                  context,
                                  fontSize: 20,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
