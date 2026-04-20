import 'package:app/controller/choose_city/choose_city_controller.dart';
import 'package:app/view/city/widget/city_widget.dart';
import 'package:app/view/city/widget/header_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCity extends StatelessWidget {
  ChooseCity({super.key});
  final ChooseCityController controller = Get.put(ChooseCityController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      HeaderImage(
                        imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVrNk8vENDV41VyEvIkVIJgwTLfUuEk0bieg&s",
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "أهلاً بك",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "اختر محافظتك لاستعراض المطاعم الخاصة بها ...",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CityWidget(
                        cityId: 1,
                        imageUrl: "https://img.icons8.com/color/1200/castle.jpg",
                        title: "حماه",
                        onTap: () => controller.selectCityAndGo(id: 1, name: "حماه"),
                      ),
                      const SizedBox(height: 20),
                      CityWidget(
                        cityId: 3,
                        imageUrl:
                            "https://image.shutterstock.com/image-vector/clock-tower-vector-illustration-on-260nw-1597739923.jpg",
                        title: "حمص",
                        onTap: () => controller.selectCityAndGo(id: 3, name: "حمص"),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (!controller.isSelectingCity.value) return const SizedBox.shrink();
              return Stack(
                children: [
                  ModalBarrier(
                    color: Colors.black54,
                    dismissible: false,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          "جاري تحميل البيانات...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
