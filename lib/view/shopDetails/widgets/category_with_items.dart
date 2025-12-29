import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
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
            SizedBox(height: 20),
            // عنوان التصنيف
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

            // Loop on items inside category
            Column(
              children: category["items"].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          // النصوص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    item["desc"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item["price"]} ريال",
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    // العداد
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.remove),
                                          color: AppColor().primaryColor,
                                          iconSize: 25,
                                        ),
                                        Text(
                                          "0",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.add),
                                          color: AppColor().primaryColor,
                                          iconSize: 25,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 3),

                          // الصورة
                          SizedBox(
                            height: 140,
                            width: 120,
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
