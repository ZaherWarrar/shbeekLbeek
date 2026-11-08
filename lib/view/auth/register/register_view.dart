import 'package:app/controller/auth/register/register_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:app/view/auth/register/widgets/go_to_login.dart';
import 'package:app/view/auth/widgets/auth_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<RegisterControllerImb>()) {
      Get.delete<RegisterControllerImb>();
    }
    Get.put(RegisterControllerImb());

    return GetBuilder<RegisterControllerImb>(
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
                    controller: controller.name,
                    validator: controller.validateName,
                    maxLength: 50,
                    onChanged: (value) =>
                        controller.validateNameOnChange(value ?? ''),
                    errorText: controller.nameError.value.isNotEmpty
                        ? controller.nameError.value
                        : null,
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthField(
                    label: '11'.tr,
                    hint: '10'.tr,
                    icon: Icons.phone_outlined,
                    controller: controller.phoneNumber,
                    validator: controller.validatePhone,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    onChanged: (value) =>
                        controller.validatePhoneOnChange(value ?? ''),
                    errorText: controller.phoneError.value.isNotEmpty
                        ? controller.phoneError.value
                        : null,
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 18)),
                  GoToLogin(onTap: () => controller.goToLogin()),
                  SizedBox(height: AuthMetrics.gap(context, 18)),
                  Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: controller.isAgree,
                          activeColor: AuthColors.purple,
                          side: const BorderSide(color: AuthColors.purple),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          onChanged: controller.toggleAgree,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(text: 'أوافق على '),
                              TextSpan(
                                text: 'الشروط والأحكام',
                                style: const TextStyle(
                                  color: AuthColors.purple,
                                  fontWeight: FontWeight.w800,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed('/terms'),
                              ),
                              const TextSpan(text: ' و '),
                              TextSpan(
                                text: 'سياسة الخصوصية',
                                style: const TextStyle(
                                  color: AuthColors.purple,
                                  fontWeight: FontWeight.w800,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed('/privacy'),
                              ),
                            ],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  if (!controller.isAgree && controller.showAgreeError.value)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'يجب الموافقة على الشروط والأحكام',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ),
                  SizedBox(height: AuthMetrics.gap(context, 25)),
                  AuthPrimaryButton(
                    title: 'إنشاء حساب',
                    loading: loading,
                    onTap: () => _submit(controller),
                  ),
                  SizedBox(height: AuthMetrics.gap(context, 12)),
                  AuthOutlineButton(
                    title: 'الدخول كضيف',
                    onTap: () async {
                      final session = Get.find<SessionService>();
                      if (!session.isLoggedIn) {
                        await session.setGuest(true);
                      }
                      Get.toNamed(AppRoutes.chooseCity);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(RegisterControllerImb controller) {
    if (!controller.formStat.currentState!.validate()) {
      AppSnackbar.show(
        'تنبيه',
        'يرجى تصحيح الأخطاء في الحقول',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!controller.isAgree) {
      controller.showAgreeError.value = true;
      controller.update();
      AppSnackbar.show(
        'تنبيه',
        'يجب الموافقة على سياسة الخصوصية أولاً',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    controller.showAgreeError.value = false;
    controller.update();
    controller.register();
  }
}
