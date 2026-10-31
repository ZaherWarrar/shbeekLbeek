import 'dart:async';

import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/core/shared/notifications/notification_api.dart';
import 'package:app/core/shared/notifications/notification_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/binding/my_binding.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/localization/changelocal.dart';
import 'package:app/localization/translation.dart';
import 'package:app/view/splash/startup_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => SessionService().init());
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
  runApp(MyApp(initialRoute: initialRoute));
  unawaited(_startPlatformServices());
}

Future<void> _startPlatformServices() async {
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Firebase init skipped: $e');
    return;
  }

  try {
    await NotificationApi().init().timeout(const Duration(seconds: 8));
    NotificationApi.syncDeviceToken();
  } catch (e) {
    debugPrint('Notification init skipped: $e');
  }
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
        _openPendingNotification();
        return StartupSplash(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

bool _pendingNotificationScheduled = false;

void _openPendingNotification() {
  if (_pendingNotificationScheduled) return;
  _pendingNotificationScheduled = true;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final pending = NotificationRouter.pending;
    if (pending != null && Get.isRegistered<NotificationsController>()) {
      await Get.find<NotificationsController>().markAsRead(pending.id);
    }
    await NotificationRouter.flushPending();
  });
}
