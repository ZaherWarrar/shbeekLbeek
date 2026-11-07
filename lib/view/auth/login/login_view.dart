import 'package:app/controller/auth/login/login_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LoginControllerImb>()) {
      Get.put(LoginControllerImb());
    }

    return GetBuilder<LoginControllerImb>(
      builder: (controller) {
        final loading = controller.statusRequest == StatusRequest.loading;
        return AuthScreen(
          child: AuthCard(
            child: Form(
              key: controller.formStat,
              child: Column(
                children: [
                  Text(
                    'الدخول أو إنشاء حساب',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthField(
                    label: '11'.tr,
                    hint: '10'.tr,
                    icon: Icons.phone_outlined,
                    controller: controller.phoneNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: controller.validatePhone,
                    maxLength: 10,
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 18)),
                  CheckboxListTile(
                    value: controller.agreed,
                    onChanged: loading
                        ? null
                        : (value) => controller.setAgreement(value ?? false),
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'أوافق على سياسة الخصوصية والشروط والأحكام',
                    ),
                  ),
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.privacy),
                        child: const Text('سياسة الخصوصية'),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.terms),
                        child: const Text('الشروط والأحكام'),
                      ),
                    ],
                  ),
                  if (controller.error != null)
                    Text(
                      controller.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthPrimaryButton(
                    title: 'إرسال رمز التحقق',
                    loading: loading,
                    onTap: () => controller.login(),
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 12)),
                  AuthOutlineButton(
                    title: 'الدخول كضيف',
                    onTap: controller.continueAsGuest,
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
