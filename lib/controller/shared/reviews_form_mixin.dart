import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ReviewsFormMixin on GetxController {
  SessionService get session;

  StatusRequest reviewsStatus = StatusRequest.none;
  final TextEditingController reviewTextController = TextEditingController();
  int reviewRating = 5;
  bool isSubmittingReview = false;
  int? editingReviewId;

  Future<void> reloadReviews();

  void setReviewRating(int value) {
    reviewRating = value.clamp(1, 5);
    update();
  }

  void beginEditFromReview({int? id, int? rating, String? text}) {
    editingReviewId = id;
    reviewRating = (rating ?? 5).clamp(1, 5);
    reviewTextController.text = (text ?? '').toString();
    update();
  }

  void resetReviewForm() {
    editingReviewId = null;
    reviewRating = 5;
    reviewTextController.clear();
    update();
  }

  void disposeReviewControllers() {
    reviewTextController.dispose();
  }

  Future<bool> _ensureLoggedIn() async {
    if (session.isLoggedIn) return true;
    Get.snackbar('تنبيه', 'يجب تسجيل الدخول أولاً');
    Get.toNamed(AppRoutes.login);
    return false;
  }

  Future<void> submitReviewVia(Future<Object> Function() apiCall) async {
    if (isSubmittingReview) return;
    if (!await _ensureLoggedIn()) return;

    isSubmittingReview = true;
    update();

    final stat = handlingData(await apiCall());
    if (stat == StatusRequest.success) {
      reviewTextController.clear();
      reviewRating = 5;
      await reloadReviews();
      Get.back();
      Get.snackbar('تم', 'تم إرسال تقييمك بنجاح');
    } else {
      Get.snackbar('خطأ', 'فشل إرسال التقييم');
    }

    isSubmittingReview = false;
    update();
  }

  Future<void> updateReviewVia(Future<Object> Function() apiCall) async {
    final rid = editingReviewId;
    if (rid == null || rid <= 0) return;
    if (isSubmittingReview) return;
    if (!await _ensureLoggedIn()) return;

    isSubmittingReview = true;
    update();

    final stat = handlingData(await apiCall());
    if (stat == StatusRequest.success) {
      await reloadReviews();
      resetReviewForm();
      Get.back();
      Get.snackbar('تم', 'تم تعديل التقييم بنجاح');
    } else {
      Get.snackbar('خطأ', 'فشل تعديل التقييم');
    }

    isSubmittingReview = false;
    update();
  }

  Future<void> deleteReviewVia(
    int reviewId,
    Future<Object> Function() apiCall,
  ) async {
    if (reviewId <= 0) return;
    if (isSubmittingReview) return;
    if (!await _ensureLoggedIn()) return;

    isSubmittingReview = true;
    update();

    final stat = handlingData(await apiCall());
    if (stat == StatusRequest.success) {
      await reloadReviews();
      Get.snackbar('تم', 'تم حذف التقييم');
    } else {
      Get.snackbar('خطأ', 'فشل حذف التقييم');
    }

    isSubmittingReview = false;
    update();
  }

  bool applyReviewsResponse(dynamic res, void Function(Map<String, dynamic>) onSuccess) {
    reviewsStatus = StatusRequest.loading;
    update();

    final stat = handlingData(res);
    if (stat != StatusRequest.success || res is! Map<String, dynamic>) {
      reviewsStatus = res is StatusRequest ? res : StatusRequest.failure;
      update();
      return false;
    }

    onSuccess(res);
    reviewsStatus = StatusRequest.success;
    update();
    return true;
  }
}
