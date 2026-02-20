import 'package:app/controller/choose_city/choose_city_controller.dart';
import 'package:app/core/constant/routes/app_routes.dart';
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
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // الصورة
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
                    onTap: () async {
                      await controller.selectCity(id: 1, name: "حماه");
                      Get.offAllNamed(AppRoutes.start);
                    },
                  ),
      
                  const SizedBox(height: 20),
      
                  CityWidget(
                    cityId: 3,
                    imageUrl:
                        "https://image.shutterstock.com/image-vector/clock-tower-vector-illustration-on-260nw-1597739923.jpg",
                    title: "حمص",
                    onTap: () async {
                      await controller.selectCity(id: 3, name: "حمص");
                      Get.offAllNamed(AppRoutes.start);
                    },
                  ),
      
                  const SizedBox(height: 24), // مسافة أسفل للراحة عند التمرير
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
