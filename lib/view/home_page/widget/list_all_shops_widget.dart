import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ListAllShopsWidget extends StatelessWidget {
  const ListAllShopsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "تصفح كل المحلات ",
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, fontSize: 35),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final item = controller.items[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  width: w * 0.9,
                  height: 120,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      // ====== الصورة =======
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              item.imageUrl ?? " ",
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.imagesLogo,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),
                      // ============== العناوين والتفاصيل ==============
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontSize: getResponsiveFontSize(
                                      context,
                                      fontSize: 25,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_border_purple500_outlined,
                                    color: AppColor().primaryColor,
                                    //    size: h * 0.028,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "4.5",
                                    //     style: TextStyle(fontSize: h * 0.02),
                                  ),
                                  SizedBox(width: 5),

                                  Text(
                                    "(200)",
                                    style: TextStyle(
                                      color: AppColor().descriptionColor,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    // size: h * 0.025,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "15-25 دقيقة",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      //   fontSize: h * 0.018,
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
            ),
          ],
        );
      },
    );
  }
}
