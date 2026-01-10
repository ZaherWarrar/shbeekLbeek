import 'package:app/binding/all_shops_binding.dart';
import 'package:app/binding/cart_binding.dart';
import 'package:app/binding/order_binding.dart';
import 'package:app/binding/otp_binding.dart';
import 'package:app/binding/shop_details_binding.dart';
import 'package:app/view/Cart/cart_view.dart';
import 'package:app/view/about_app/about_app.dart';
import 'package:app/view/adress/binding/address_binding.dart';
import 'package:app/view/adress/view/address_page.dart';
import 'package:app/view/allShops/view/all_shops_view.dart';
import 'package:app/view/auth/login/login_view.dart';
import 'package:app/view/auth/register/register_view.dart';
import 'package:app/view/auth/verification/otp_view.dart';
import 'package:app/view/bottomNavBar/main_view.dart';
import 'package:app/view/city/choose_city.dart';
import 'package:app/view/contact_us_view/contact_us.dart';
import 'package:app/view/favorets/favorites_view.dart';
import 'package:app/view/order/order_confirmation_view.dart';
import 'package:app/view/orderHistoory/view/order_his_view.dart';
import 'package:app/view/payment/binding/payment_binding.dart';
import 'package:app/view/payment/view/payment_view.dart';
import 'package:app/view/privacy/privacy_view.dart';
import 'package:app/view/shopDetails/shop_details_view.dart';
import 'package:app/view/termsPage/terms_pages.dart';
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
  static const String orderConfirmation = '/orderConfirmation';
  static const String favorates = '/fav';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String contact = '/contact';
  static const String about = '/about';
  static const String ordhis = '/OrderHistoryPage';
  static const String addrslis = '/Addresspage';
  static const String paympa = '/Paymentpage';
  
  

  static final routes = [
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(binding: OtpBinding(), name: otp, page: () => const OtpView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: chooseCity, page: () => ChooseCity()),
    GetPage(
      binding: AllShopsBinding(),
      name: allShops,
      page: () => const StoresPage(),
    ),
    GetPage(
      binding: CartBinding(),
      name: cartView,
      page: () => const CartView(),
    ),
    GetPage(
      binding: ShopDetailsBinding(),
      name: resturantDetails,
      page: () => const ShopDetailsView(),
    ),
    GetPage(
      binding: OrderBinding(),
      name: orderConfirmation,
      page: () => const OrderConfirmationView(),
    ),
    GetPage(name: home, page: () => MainView()),
    GetPage(name: favorates, page: () => FavoritesView()),
    GetPage(name: privacy, page: () => const PrivacyPolicyPage()),
    GetPage(name: terms, page: () => const TermsPage()),
    GetPage(name: contact, page: () => const ContactUsPage()),
    GetPage(name: about, page: () => const AboutAppPage()),
    GetPage(name: ordhis, page: () => OrderHistoryPage()),
    GetPage(
      name: addrslis,
      page: () => AddressPage(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: paympa,
      page: () => PaymentPage(),
      binding: PaymentBinding(),
    ),
  ];
}
