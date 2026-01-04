import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class CategoryWithItems extends StatelessWidget {
  const CategoryWithItems({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "name": "الشاورما",
        "items": [
          {
            "title": "شاورما دجاج",
            "desc": "شريحة دجاج مشوي مع خس وطماطم وصوص ثوم",
            "price": 20,
            "image":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTndzoEyM5zdNSAK1Gr7UxVaxCjuPu1E9Xm0g&s",
          },
          {
            "title": "شاورما لحم",
            "desc": "لحم مشوي مع بصل وخس وصوص خاص",
            "price": 25,
            "image":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTndzoEyM5zdNSAK1Gr7UxVaxCjuPu1E9Xm0g&s",
          },
        ],
      },
      {
        "name": "السندويش",
        "items": [
          {
            "title": "سندويش فلافل",
            "desc": "فلافل مقرمش مع خضار وصوص طحينة",
            "price": 10,
            "image":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTndzoEyM5zdNSAK1Gr7UxVaxCjuPu1E9Xm0g&s",
          },
          {
            "title": "سندويش زنجر",
            "desc": "دجاج زنجر مقرمش مع خس ومايونيز",
            "price": 18,
            "image":
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTndzoEyM5zdNSAK1Gr7UxVaxCjuPu1E9Xm0g&s",
          },
        ],
      },
    ];

    return Column(
      children: categories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.02),

            /// عنوان التصنيف
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  category["name"],
                  style: TextStyle(
                    color: AppColor().titleColor,
                    fontSize: getResponsiveFontSize(context, fontSize: 40),
                  ),
                ),
              ),
            ),

            /// العناصر داخل التصنيف
            Column(
              children: category["items"].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: h * 0.18, // Responsive height
                    decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03,
                        vertical: h * 0.015,
                      ),
                      child: Row(
                        children: [
                          /// النصوص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getResponsiveFontSize(
                                      context,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  item["desc"],
                                  style: TextStyle(
                                    fontSize: getResponsiveFontSize(
                                      context,
                                      fontSize: 14,
                                    ),
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: h * 0.01),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item["price"]} ريال",
                                      style: TextStyle(
                                        color: AppColor().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: getResponsiveFontSize(
                                          context,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),

                                    /// العداد
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.remove),
                                          color: AppColor().primaryColor,
                                          iconSize: w * 0.06,
                                        ),
                                        Text(
                                          "0",
                                          style: TextStyle(
                                            fontSize: getResponsiveFontSize(
                                              context,
                                              fontSize: 20,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.add),
                                          color: AppColor().primaryColor,
                                          iconSize: w * 0.06,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: w * 0.02),

                          /// الصورة
                          SizedBox(
                            height: h * 0.16,
                            width: w * 0.28,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                item["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}
