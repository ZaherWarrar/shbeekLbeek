// lib/app/shared/widgets/slider_widget.dart
import 'package:app/controller/home/home_controller.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Duration? interval;
  final bool autoPlay;
  final double imageWidth;
  final List<void Function()>? onTapActions;
    final HomeControllerImp controller ;

  const SliderWidget({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.interval,
    this.autoPlay = true,
    this.imageWidth = 300,
    this.onTapActions, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
   

    if (interval != null) {
      controller.autoPlayDelay = interval!;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedFraction = imageWidth / screenWidth;

    controller.pageController = PageController(
      initialPage: controller.initialPage,
      viewportFraction: calculatedFraction,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.extendedSlides.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              final slide = controller.extendedSlides[index];

              // حساب index الحقيقي داخل القائمة الأصلية
              final realIndex = (index - 1) % controller.slides.length;

              return GestureDetector(
                onTap: () {
                  if (onTapActions != null &&
                      realIndex >= 0 &&
                      realIndex < onTapActions!.length) {
                    onTapActions![realIndex]();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(slide.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
