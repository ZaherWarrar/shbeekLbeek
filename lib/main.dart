import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/binding/my_binding.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/services.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/localization/changelocal.dart';
import 'package:app/localization/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  // التحقق من تسجيل الدخول
  final userPreferences = UserPreferences();
  final token = await userPreferences.getToken();
  final initialRoute = (token != null && token.isNotEmpty)
      ? AppRoutes.home
      : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

late double w;
late double h;

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

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
      initialRoute: initialRoute,
      getPages: AppRoutes.routes,
      // جعل التطبيق RTL بشكل دائم
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
