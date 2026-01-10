import 'package:app/core/constant/app_color.dart';
import 'package:app/view/privacy/widget/footer_card.dart';
import 'package:app/view/privacy/widget/intro_card.dart';
import 'package:app/view/privacy/widget/section_card.dart';
import 'package:flutter/material.dart';

/// صفحة سياسة الخصوصية
/// جاهزة للنشر على Google Play و App Store
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'سياسة الخصوصية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor().titleColor,
          ),
        ),
        iconTheme:  IconThemeData(color: AppColor().titleColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          IntroCard(),

          SectionCard(
            title: 'المعلومات التي نقوم بجمعها',
            content: [
              'الاسم',
              'البريد الإلكتروني',
              'رقم الهاتف',
              'معلومات الموقع (بعد الموافقة)',
              'بيانات الاستخدام داخل التطبيق',
            ],
          ),

          SectionCard(
            title: 'كيفية استخدام المعلومات',
            content: [
              'تقديم وتحسين خدمات التطبيق',
              'معالجة الطلبات وتنفيذها',
              'التواصل مع المستخدم عند الحاجة',
              'تحسين تجربة المستخدم',
              'إرسال إشعارات متعلقة بالخدمة',
            ],
          ),

          SectionCard(
            title: 'مشاركة المعلومات',
            content: [
              'عدم بيع أو مشاركة البيانات مع أطراف خارجية',
              'مشاركة البيانات فقط عند الحاجة لتقديم الخدمة',
              'الالتزام بالقوانين والأنظمة المعمول بها',
            ],
          ),

          SectionCard(
            title: 'حماية البيانات',
            content: [
              'استخدام إجراءات تقنية وتنظيمية لحماية البيانات',
              'منع الوصول غير المصرح به أو التعديل أو الإفصاح',
            ],
          ),

          SectionCard(
            title: 'حقوق المستخدم',
            content: [
              'الوصول إلى البيانات الشخصية',
              'تعديل أو تحديث البيانات',
              'طلب حذف الحساب والبيانات',
              'إيقاف استقبال الإشعارات',
            ],
          ),

          SectionCard(
            title: 'خصوصية الأطفال',
            content: [
              'التطبيق غير موجه للأطفال دون سن 13 عامًا',
              'عدم جمع بيانات شخصية للأطفال عن قصد',
            ],
          ),

          SectionCard(
            title: 'التعديلات على سياسة الخصوصية',
            content: [
              'الحق في تعديل السياسة في أي وقت',
              'إشعار المستخدمين عند التغييرات الجوهرية',
            ],
          ),

          FooterCard(),
        ],
      ),
    );
  }
}
