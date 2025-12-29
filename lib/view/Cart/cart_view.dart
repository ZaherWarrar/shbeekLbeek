import 'package:app/view/Cart/widget/cart_item_widget.dart';
import 'package:app/view/Cart/widget/discount_code_widget.dart';
import 'package:app/view/Cart/widget/summary_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/core/shared/custom_app_bar.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  // ✅ بيانات وهمية (جاهزة للاستبدال بـ API)
  final List<Map<String, dynamic>> cartItems = const [
    {
      "title": "وجبة برجر لحم",
      "subtitle": "وجبة مميزة شامل",
      "price": 35,
      "quantity": 1,
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
    },
    {
      "title": "بيتزا مارجريتا",
      "subtitle": "بيتزا إيطالي",
      "price": 45,
      "quantity": 2,
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
    },
    {
      "title": "مشروب غازي",
      "subtitle": "كوكاكولا",
      "price": 5,
      "quantity": 3,
      "image": "https://images.unsplash.com/photo-1550547660-d9450f859349",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "السلة"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("المنتجات", style: TextStyle(fontSize: 22)),
                ),

                // ✅ عرض البيانات من الـ Map
                ...cartItems.map(
                  (item) => CartItemWidget(
                    title: item['title'],
                    subtitle: item['subtitle'],
                    price: item['price'],
                    quantity: item['quantity'],
                    image: item['image'],
                  ),
                ),

                const SizedBox(height: 10),

                const DiscountCodeWidget(),

                const SizedBox(height: 20),

                const SummaryRowWidget("المجموع الفرعي", "140 ليرة"),
                const SummaryRowWidget("رسوم التوصيل", "10 ليرة"),
                const SummaryRowWidget("الخصم", "0 ليرة"),
                const Divider(),
                const SummaryRowWidget(
                  "المجموع الإجمالي",
                  "150 ليرة",
                  isTotal: true,
                ),
              ],
            ),
          ),

          // زر إتمام الطلب
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "إتمام الطلب | 150 ليرة",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
