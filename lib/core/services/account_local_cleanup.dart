import 'package:app/controller/address/address_controller.dart';
import 'package:app/controller/auth/otp/otp_controller.dart';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/controller/favorites/favorites_controller.dart';
import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/controller/orderHistoory/order_his_controller.dart';
import 'package:app/controller/orderHistoory/external_orders_controller.dart';
import 'package:app/controller/profile/profile_controller.dart';
import 'package:app/controller/wallet/wallet_controller.dart';
import 'package:app/core/shared/notifications/notification_router.dart';
import 'package:app/core/shared/notifications/notification_api.dart';
import 'package:get/get.dart';

/// Only local state. Never confirms/cancels orders on the server.
Future<void> clearAccountControllers() async {
  NotificationRouter.pending = null;
  await Get.delete<OtpController>(force: true);
  await Get.delete<ProfileController>(force: true);
  await Get.delete<WalletController>(force: true);
  await Get.delete<ExternalDeliveryController>(force: true);
  await Get.delete<OrderHisController>(force: true);
  await Get.delete<ExternalOrdersController>(force: true);
  await Get.delete<FavoritesController>(force: true);
  await Get.delete<CartController>(force: true);
  await Get.delete<OrderController>(force: true);
  await Get.delete<AddressController>(force: true);
  await Get.delete<NotificationsController>(force: true);
  await NotificationApi.clearDisplayedNotifications();
  // Recreate empty permanent dependencies required by the existing app shell.
  Get.put(CartController(), permanent: true);
  Get.put(OrderController(), permanent: true);
  Get.put(AddressController(), permanent: true);
  Get.put(NotificationsController(), permanent: true);
  Get.lazyPut<FavoritesController>(() => FavoritesController(), fenix: true);
}
