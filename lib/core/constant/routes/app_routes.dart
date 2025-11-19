import 'package:app/binding/otp_binding.dart';
import 'package:app/view/auth/login/login_view.dart';
import 'package:app/view/auth/register/register_view.dart';
import 'package:app/view/auth/verification/otp_view.dart';
import 'package:app/view/home_page/home_page_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/homePage';

  static final routes = [
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(binding: OtpBinding(), name: otp, page: () => const OtpView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: home, page: () => HomePageView()),
  ];
}
