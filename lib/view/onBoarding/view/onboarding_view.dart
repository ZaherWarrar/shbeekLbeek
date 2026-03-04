import 'package:app/view/onBoarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  static const Color kYellow = Color(0xFFF2C94C);
  static const Color kPurple = Color(0xFF6C63FF);
  static const Color kGreyText = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: GetBuilder<OnboardingController>(
          builder: (c) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFF7DC),
                    Color(0xFFF3F4F6),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    /// TOP BAR
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: (c.index + 1) / c.pages.length,
                                minHeight: 6,
                                backgroundColor: Colors.black.withValues(
                                  alpha: 0.06,
                                ),
                                valueColor: const AlwaysStoppedAnimation(
                                  kPurple,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: c.skip,
                            style: TextButton.styleFrom(
                              foregroundColor: kPurple,
                            ),
                            child: const Text(
                              "تخطي",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// PAGEVIEW
                    Expanded(
                      child: PageView.builder(
                        controller: c.pageController,
                        itemCount: c.pages.length,
                        onPageChanged: c.onPageChanged,
                        itemBuilder: (_, i) {
                          final page = c.pages[i];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),

                                /// IMAGE
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              kYellow.withValues(alpha: 0.25),
                                              kPurple.withValues(alpha: 0.12),
                                              Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        page.image,
                                        height: 280,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 18),

                                /// TEXT CARD
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        page.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        page.desc,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: kGreyText,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// DOTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(c.pages.length, (i) {
                        final active = c.index == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: active ? 24 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: active
                                ? kPurple.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 10),

                    /// BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                      child: Row(
                        children: [
                          /// BACK BUTTON
                          if (c.index != 0)
                            SizedBox(
                              width: 54,
                              height: 54,
                              child: IconButton(
                                onPressed: () {
                                  c.pageController.previousPage(
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.7,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                          if (c.index != 0) const SizedBox(width: 12),

                          /// NEXT BUTTON
                          Expanded(
                            flex: c.index == 0 ? 1 : 5,
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: c.next,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kYellow,
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      c.index == c.pages.length - 1
                                          ? "ابدأ الآن"
                                          : "التالي",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      c.index == c.pages.length - 1
                                          ? Icons.check_circle_rounded
                                          : Icons.arrow_forward_rounded,
                                      size: 20,
                                      color: Colors
                                          .black87, // نفس لون foregroundColor للزر
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
