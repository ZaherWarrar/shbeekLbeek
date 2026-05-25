import 'package:app/data/datasource/model/store_review_model.dart';
import 'package:app/view/widgets/review_display_card.dart';
import 'package:flutter/material.dart';

class ShopReviewCard extends StatelessWidget {
  const ShopReviewCard({
    super.key,
    required this.review,
    required this.isMine,
    this.onEdit,
    this.onDelete,
  });

  final StoreReviewModel review;
  final bool isMine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ReviewDisplayCard(
      reviewId: review.id,
      rating: review.rating ?? 0,
      text: review.text ?? '',
      createdAt: review.createdAt,
      userName: review.user?.name ?? '',
      avatarUrl: review.user?.avatarUrl,
      isMine: isMine,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
