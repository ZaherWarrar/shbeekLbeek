// lib/app/shared/widgets/slider_widget.dart
import 'package:app/controller/home/home_controller.dart';
import 'package:app/data/datasource/model/slider_model.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Duration? interval;
  final bool autoPlay;
  final double imageWidth;

  final HomeControllerImp controller;

  const SliderWidget({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.interval,
    this.autoPlay = true,
    this.imageWidth = 300,

    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (interval != null) {
      controller.autoPlayDelay = interval!;
    }

    // إذا لم تكن هناك slides، لا نعرض السلايدر
    if (controller.extendedSlides.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedFraction = imageWidth / screenWidth;

    // تهيئة pageController فقط إذا لم يكن موجوداً أو تم dispose
    if (controller.pageController == null ||
        !controller.pageController!.hasClients) {
      controller.pageController?.dispose();
      controller.pageController = PageController(
        initialPage: controller.initialPage,
        viewportFraction: calculatedFraction,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: controller.pageController != null
              ? PageView.builder(
                  controller: controller.pageController!,
                  itemCount: controller.extendedSlides.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final slide = controller.extendedSlides[index];

                    // حساب index الحقيقي داخل القائمة الأصلية

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: _SlideImage(slide: slide),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SlideImage extends StatelessWidget {
  const _SlideImage({required this.slide});

  final SliderModel slide;

  static Widget _errorPlaceholder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = slide.imageUrl ?? '';
    if (slide.isAssetImage) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: _errorPlaceholder,
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: _errorPlaceholder,
    );
  }
}
