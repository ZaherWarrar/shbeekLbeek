import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/binding/my_binding.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/localization/changelocal.dart';
import 'package:app/localization/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  تهيئة SessionService
  await Get.putAsync(() => SessionService().init());

  //  تهيئة Changelocal مرة واحدة فقط
  Get.put(Changelocal());

  final session = Get.find<SessionService>();

  // 👇 تحديد أول صفحة
  String initialRoute;


   if (!session.isOnboardingDone) {
    initialRoute = AppRoutes.onboarding;
  } else if (session.isLoggedIn) {
    initialRoute = AppRoutes.home; 
  } else {
    initialRoute = AppRoutes.login;
  }
  runApp( MyApp(initialRoute: initialRoute));
}

late double w;
late double h;

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.sizeOf(context).width;
    h = MediaQuery.sizeOf(context).height;

    //  جلب Changelocal بدون إنشاء جديد
    final controller = Get.find<Changelocal>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      translations: MyTranslation(),

      //  اللغة المحفوظة
      locale: controller.language,

      //  الثيم المحفوظ
      theme: controller.appTheme,

      initialBinding: InitialBindings(),
      initialRoute: initialRoute,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      getPages: AppRoutes.routes,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
