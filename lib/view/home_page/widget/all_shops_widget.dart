import 'dart:ffi';

import 'package:app/controller/all_shops/all_shops_controller.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllShops extends StatelessWidget {
  const AllShops({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllShopsController());
    //مشان التحكم بحجم العنصر اذا كان الجوال بالطول
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: controller.shops.length,
        itemBuilder: (context, index) {
          final item = controller.shops[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.015,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // ====== الصورة =======
                Container(
                  padding: EdgeInsets.all(5),
                  height: isPortrait ? h * 0.13 : h * 0.35,
                  child: Expanded(
                    flex: isPortrait ? 4 : 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(item.image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: w * 0.05),
                // ============== العناوين والتفاصيل ==============
                Container(
                  padding: EdgeInsets.all(5),
                  height: isPortrait ? h * 0.12 : h * 0.3,
                  width: w * 0.4,
                  child: Expanded(
                    flex: isPortrait ? 6 : 8, // عرض النصوص
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            //  fontSize: h * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.describtion,
                          style: TextStyle(
                            //   fontSize: h * 0.018,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_border_purple500_outlined,
                              color: const Color.fromARGB(255, 255, 242, 0),
                              //    size: h * 0.028,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${item.rating}",
                              //     style: TextStyle(fontSize: h * 0.02),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.alarm,
                              // size: h * 0.025,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${item.minDeliveryTime} -",
                              style: TextStyle(
                                color: Colors.grey[700],
                                //   fontSize: h * 0.018,
                              ),
                            ),
                            Text(
                              "${item.maxDeliveryTime} ",
                              style: TextStyle(
                                color: Colors.grey[700],
                                //    fontSize: h * 0.018,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
