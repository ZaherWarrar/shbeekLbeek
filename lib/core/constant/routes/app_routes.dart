import 'package:app/binding/otp_binding.dart';
import 'package:app/view/auth/login/login_view.dart';
import 'package:app/view/auth/register/register_view.dart';
import 'package:app/view/auth/verification/otp_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String project = '/project';
  static const String otp = '/otp';
  static const String userProject = "/userProject";
  static const String learneMore = "/learnMore";

  static final routes = [
    GetPage(name: splash, page: () => const LoginView()),
    GetPage(name: register, page: () => const RegisterView()),
    GetPage(binding: OtpBinding(), name: otp, page: () => const OtpView()),
    // GetPage(name: login, page: () => LoginView()),
    // GetPage(name: home, page: () => HomePage()),
    // GetPage(name: project, page: () => ProjectView()),
    // GetPage(name: userProject, page: () => DetailsUserProject()),
    // GetPage(name: learneMore, page: () => LearnMore()),
  ];
}
