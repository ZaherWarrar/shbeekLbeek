import 'package:app/controller/shared/reviews_form_mixin.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/data/datasource/model/product_review_model.dart';
import 'package:app/data/datasource/remot/product_reviews_data.dart';
import 'package:get/get.dart';

mixin ProductDetailsReviewsMixin on GetxController, ReviewsFormMixin {
  int get productId;

  ProductReviewsResponseModel? reviewsResponse;

  @override
  Future<void> reloadReviews() => fetchReviews();

  Future<void> fetchReviews() async {
    final data = ProductReviewsData(Get.find<Crud>());
    final res = await data.fetchProductReviews(productId);
    applyReviewsResponse(
      res,
      (json) => reviewsResponse = ProductReviewsResponseModel.fromJson(json),
    );
  }

  Future<void> submitReview() async {
    final data = ProductReviewsData(Get.find<Crud>());
    final text = reviewTextController.text.trim();
    await submitReviewVia(
      () => data.createReview(
        productId: productId,
        rating: reviewRating,
        text: text.isEmpty ? null : text,
      ),
    );
  }

  void beginEditReview(ProductReviewModel review) {
    beginEditFromReview(
      id: review.id,
      rating: review.rating,
      text: review.text,
    );
  }

  Future<void> updateReview() async {
    final rid = editingReviewId;
    if (rid == null) return;
    final data = ProductReviewsData(Get.find<Crud>());
    final text = reviewTextController.text.trim();
    await updateReviewVia(
      () => data.updateReview(
        reviewId: rid,
        rating: reviewRating,
        text: text.isEmpty ? null : text,
      ),
    );
  }

  Future<void> deleteReview(int reviewId) async {
    final data = ProductReviewsData(Get.find<Crud>());
    await deleteReviewVia(reviewId, () => data.deleteReview(reviewId));
  }
}
