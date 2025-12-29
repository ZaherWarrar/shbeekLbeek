import 'package:app/binding/otp_binding.dart';
import 'package:app/view/Cart/cart_view.dart';
import 'package:app/view/allShops/view/all_shops_view.dart';
import 'package:app/view/auth/login/login_view.dart';
import 'package:app/view/auth/register/register_view.dart';
import 'package:app/view/auth/verification/otp_view.dart';
import 'package:app/view/city/choose_city.dart';
import 'package:app/view/home_page/home_page_view.dart';
import 'package:app/view/shopDetails/shop_details_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/homePage';
  static const String chooseCity = '/chooseCity';
  static const String resturantDetails = '/resDe';
 static const String allShops = '/allSho';
 static const String cartView = '/carVi';
  static final routes = [
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(binding: OtpBinding(), name: otp, page: () => const OtpView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: home, page: () => HomePageView()),
    GetPage(name: chooseCity, page: () => ChooseCity()),
    GetPage(name: home, page: () => HomePageView()),
    GetPage(name: allShops, page: () => StoresPage()),
    GetPage(name: cartView, page: () => CartView()),
    GetPage(name: resturantDetails, page: () => ShopDetailsView()),
  ];
}
