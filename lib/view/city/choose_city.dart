import 'package:app/controller/choose_city/choose_city_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/city/widget/city_widget.dart';
import 'package:app/view/city/widget/header_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCity extends StatelessWidget {
  ChooseCity({super.key});

  final ChooseCityController controller = Get.put(ChooseCityController());

  static const _defaultCityImage =
      'https://img.icons8.com/color/1200/city-buildings.png';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ChooseCityController>(
          builder: (controller) {
            return Stack(
              children: [
                if (controller.shouldShowCityList)
                  Center(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            HeaderImage(
                              imageUrl:
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVrNk8vENDV41VyEvIkVIJgwTLfUuEk0bieg&s',
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'أهلاً بك',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'اختر محافظتك لاستعراض المطاعم الخاصة بها ...',
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ...controller.cities.map((city) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: CityWidget(
                                  cityId: city.id,
                                  imageUrl: city.imageUrl ?? _defaultCityImage,
                                  title: city.name,
                                  onTap: () => controller.selectCityAndGo(
                                    id: city.id,
                                    name: city.name,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (controller.citiesStatus == StatusRequest.failure)
                  _ErrorState(onRetry: controller.fetchCities)
                else
                  const SizedBox.shrink(),
                if (controller.isBootstrapping)
                  Stack(
                    children: [
                      ModalBarrier(
                        color: Colors.black54,
                        dismissible: false,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColor().primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.citiesStatus == StatusRequest.loading
                                  ? 'جاري تحميل المدن...'
                                  : 'جاري تحميل البيانات...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_city_outlined,
              size: 48,
              color: AppColor().descriptionColor,
            ),
            const SizedBox(height: 12),
            Text(
              'تعذّر تحميل المدن',
              style: TextStyle(
                color: AppColor().titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تحقق من الاتصال بالإنترنت ثم حاول مجدداً',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor().descriptionColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor().primaryColor,
                foregroundColor: AppColor().textButomColor,
              ),
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
