import 'package:flutter/material.dart';
import 'quantity_button.dart';

class CartItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int price;
  final int quantity;
  final String image;

  const CartItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$price.00 ليرة",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const QuantityButton(icon: Icons.remove),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(quantity.toString()),
                  ),
                  const QuantityButton(icon: Icons.add),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
