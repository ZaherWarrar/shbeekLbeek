import 'package:app/core/class/crud.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/controller/settings/app_settings_controller.dart';
import 'package:get/get.dart';
import 'package:app/controller/profile/account_controller.dart';
import 'package:app/controller/profile/profile_controller.dart';
import 'package:app/core/services/account_local_cleanup.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/core/shared/notifications/notification_api.dart';
import 'package:app/data/datasource/remot/account_data.dart';
import 'package:app/view/auth/widgets/account_dialogs.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    final session = Get.find<SessionService>();
    Get.put(
      AccountController(
        session: session,
        data: AccountData(Get.find<Crud>(), session),
        showNameGate: showAccountNameGate,
        confirmDeletion: confirmAccountDeletion,
        clearLocalAccount: clearAccountControllers,
        unlinkNotifications: NotificationApi.unregisterDeviceToken,
        goToLogin: () async {
          Get.offAllNamed('/');
        },
        refreshProfile: () {
          if (Get.isRegistered<ProfileController>()) {
            final profile = Get.find<ProfileController>();
            profile.checkLoginStatus();
            profile.loadUserData();
            profile.update();
          }
        },
      ),
      permanent: true,
    );
    Get.put(CartController(), permanent: true);
    // الطلب النشط والعنوان المحفوظ ظاهرين أو لازمين من أول شاشة.
    Get.put(OrderController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    // المفضلة تُحمَّل عند فتح المتجر أو تاب المفضلة، مو مع الرئيسية.
    Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(AppSettingsController(), permanent: true);
  }
}
