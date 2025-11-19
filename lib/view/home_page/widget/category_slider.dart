import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/data/datasorce/model/main_categores.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key, required this.controller});
  final HomeControllerImp controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "الأصناف",
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, fontSize: 35),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 95,
              child: ListView.builder(
                itemCount: controller.mainCat.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  MainCategoriesModel data = controller.mainCat[index];
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
                              child: Image.network(
                                data.imageUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              data.name!,
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
