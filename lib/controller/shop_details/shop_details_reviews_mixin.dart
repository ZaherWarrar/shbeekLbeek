import 'package:app/controller/shared/reviews_form_mixin.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/data/datasource/model/store_review_model.dart';
import 'package:app/data/datasource/remot/store_reviews_data.dart';
import 'package:get/get.dart';

mixin ShopDetailsReviewsMixin on GetxController, ReviewsFormMixin {
  int get storeId;

  StoreReviewsResponseModel? reviewsResponse;

  @override
  Future<void> reloadReviews() => fetchReviews();

  Future<void> fetchReviews() async {
    final data = StoreReviewsData(Get.find<Crud>());
    final res = await data.fetchStoreReviews(storeId);
    applyReviewsResponse(
      res,
      (json) => reviewsResponse = StoreReviewsResponseModel.fromJson(json),
    );
  }

  Future<void> submitReview() async {
    final data = StoreReviewsData(Get.find<Crud>());
    final text = reviewTextController.text.trim();
    await submitReviewVia(
      () => data.createReview(
        storeId: storeId,
        rating: reviewRating,
        text: text.isEmpty ? null : text,
      ),
    );
  }

  void beginEditReview(StoreReviewModel review) {
    beginEditFromReview(
      id: review.id,
      rating: review.rating,
      text: review.text,
    );
  }

  Future<void> updateReview() async {
    final rid = editingReviewId;
    if (rid == null) return;
    final data = StoreReviewsData(Get.find<Crud>());
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
    final data = StoreReviewsData(Get.find<Crud>());
    await deleteReviewVia(reviewId, () => data.deleteReview(reviewId));
  }
}
