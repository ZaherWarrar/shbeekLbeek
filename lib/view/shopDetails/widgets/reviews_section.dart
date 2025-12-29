import 'package:app/view/shopDetails/widgets/add_review_card.dart';
import 'package:app/view/shopDetails/widgets/rivew_Item_widget.dart';
import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  final double h;
  final double w;

  const ReviewsSection({super.key, required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AddReviewCardWidget(),
        ReviewItemWidget(
          name: "سارة عبدالله",
          time: "منذ يومين",
          rating: 5,
          comment: "البرجر كان رائع...",
        ),
      ],
    );
  }
}
