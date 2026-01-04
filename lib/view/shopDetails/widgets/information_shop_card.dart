import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class InformationShopCard extends StatelessWidget {
  const InformationShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                      height: 180,
                      width: 350,
                      decoration: BoxDecoration(
                        color: AppColor().backgroundColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // اسم المطعم
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "برجر فاكتوري",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor().titleColor,
                                  ),
                                ),
  //////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
                                Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      148,
                                      248,
                                      228,
                                      198,
                                    ), // برتقالي فاتح
                                    shape: BoxShape.circle, // دائرة كاملة
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets
                                          .zero, 
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: AppColor().primaryColor,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),


///////////////////////////////////////////////////////////////////                                
                              ],
                            ),
                            SizedBox(height: 10),

                            // التقييم + النوع
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      148,
                                      248,
                                      228,
                                      198,
                                    ), // برتقالي فاتح
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // دائرة كاملة
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets
                                          .zero, // مهم جداً لحتى ما يكبر الأيقونة
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.star_border,
                                        color: AppColor().primaryColor,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "4.8 (500+ تقييم) ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),

                            // وقت التوصيل + السعر
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200, // برتقالي فاتح
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // دائرة كاملة
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.motorcycle_rounded,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "التوصيل خلال 25-35 دقيقة ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),

                            // حالة الفتح + الساعات
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      149,
                                      197,
                                      225,
                                      165,
                                    ), // برتقالي فاتح
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // دائرة كاملة
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: Icon(
                                        color: Colors.green,
                                        Icons.timer_outlined,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "مفتوح الآن - 11:00 ص - 02:00 ص",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
  }
}