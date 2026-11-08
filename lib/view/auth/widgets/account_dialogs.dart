import 'package:app/controller/profile/account_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showAccountNameGate() async {
  await Get.dialog<void>(const AccountNameDialog(), barrierDismissible: false);
}

Future<bool> confirmAccountDeletion() async {
  return await Get.dialog<bool>(
        const AccountDeletionDialog(),
        barrierDismissible: false,
      ) ??
      false;
}

class AccountNameDialog extends StatefulWidget {
  const AccountNameDialog({super.key});
  @override
  State<AccountNameDialog> createState() => _AccountNameDialogState();
}

class _AccountNameDialogState extends State<AccountNameDialog> {
  final input = TextEditingController();
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        final known = controller.session.isNameKnown;
        final busy = controller.savingName || controller.leaving;
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColor().backgroundColorCard,
            title: Text(
              known ? 'استكمال الاسم' : 'تعذر التحقق من بيانات الحساب',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    known
                        ? 'أدخل اسمك لإكمال حسابك. يُطلب الاسم مرة واحدة فقط.'
                        : 'تعذر التحقق من بيانات حسابك. سجّل الدخول مجدداً أو تواصل مع الدعم قبل إنشاء طلب.',
                  ),
                  if (known) ...[
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('account-name'),
                      controller: input,
                      textDirection: TextDirection.rtl,
                      enabled: !busy,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      onSubmitted: busy ? null : (_) => _save(controller),
                    ),
                  ],
                  if (controller.nameError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      controller.nameError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: busy ? null : controller.leaveAccount,
                child: const Text('تسجيل الخروج'),
              ),
              if (known)
                ElevatedButton(
                  onPressed: busy ? null : () => _save(controller),
                  child: controller.savingName
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('حفظ الاسم'),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save(AccountController controller) async {
    final saved = await controller.saveName(input.text);
    if (saved && mounted) Get.back<void>();
  }
}

class AccountDeletionDialog extends StatelessWidget {
  const AccountDeletionDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor().backgroundColorCard,
      title: const Text('حذف الحساب'),
      content: const Text(
        'هل تريد إرسال طلب حذف حسابك؟ تخضع معالجة الحساب والبيانات لسياسة الخدمة. هذا الإجراء لا يلغي طلبات التوصيل تلقائياً.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Get.back(result: true),
          child: const Text('حذف الحساب'),
        ),
      ],
    );
  }
}
