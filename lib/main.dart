import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/binding/my_binding.dart';
import 'package:app/core/services/services.dart';
import 'package:app/localization/changelocal.dart';
import 'package:app/localization/translation.dart';
import 'core/constant/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  runApp(const MyApp());
} 






late double w;
late double h;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.sizeOf(context).width;
    h = MediaQuery.sizeOf(context).height;
    Changelocal controller = Get.put(Changelocal());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: MyTranslation(),
      locale: controller.language,
      theme: controller.appTheme,
      initialBinding: InitialBindings(),
      getPages: AppRoutes.routes,
    );
  }
}
