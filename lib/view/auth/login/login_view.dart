import 'package:app/controller/auth/login/login_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/valid_function.dart';
import 'package:app/view/auth/login/widgets/go_to_register.dart';
import 'package:app/view/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<LoginControllerImb>()) {
      Get.delete<LoginControllerImb>();
    }
    Get.put(LoginControllerImb());

    return GetBuilder<LoginControllerImb>(
      builder: (controller) {
        final loading = controller.statusRequest == StatusRequest.loading;
        return AuthScreen(
          child: AuthCard(
            child: Form(
              key: controller.formStat,
              child: Column(
                children: [
                  AuthField(
                    label: '3'.tr,
                    hint: '2'.tr,
                    icon: Icons.mail_outline,
                    controller: controller.email,
                    validator: (val) =>
                        validTextForm(val ?? '', 'email', 100, 3),
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthField(
                    label: '11'.tr,
                    hint: '10'.tr,
                    icon: Icons.phone_outlined,
                    controller: controller.phoneNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (val) =>
                        validTextForm(val ?? '', 'name', 100, 3),
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 18)),
                  GoToRegister(onTap: () => controller.goRegister()),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthPrimaryButton(
                    title: '1'.tr,
                    loading: loading,
                    onTap: () => controller.login(),
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 12)),
                  AuthOutlineButton(
                    title: 'الدخول كضيف',
                    onTap: () => Get.toNamed(AppRoutes.chooseCity),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
