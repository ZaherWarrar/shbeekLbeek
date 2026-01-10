import 'package:app/view/termsPage/widget/footer_card.dart';
import 'package:app/view/termsPage/widget/intro_card.dart';
import 'package:app/view/termsPage/widget/section_card.dart';
import 'package:flutter/material.dart';

/// صفحة الشروط والأحكام
/// جاهزة للنشر على Google Play و App Store
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الشروط والأحكام',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TermsIntroCard(),

          TermsSectionCard(
            title: 'استخدام التطبيق',
            content: [
              'يجب استخدام التطبيق بشكل قانوني وأخلاقي',
              'يُمنع إساءة استخدام الخدمات أو محاولة اختراق النظام',
            ],
          ),

          TermsSectionCard(
            title: 'الطلبات والخدمات',
            content: [
              'جميع الطلبات تخضع لسياسات المتاجر المتعاقدة معنا',
              'التطبيق يعمل كوسيط بين المستخدم والمتاجر',
            ],
          ),

          TermsSectionCard(
            title: 'المسؤولية',
            content: [
              'لا يتحمل التطبيق مسؤولية التأخير الناتج عن أطراف ثالثة',
              'التطبيق غير مسؤول عن جودة المنتجات المقدمة من المتاجر',
            ],
          ),

          TermsSectionCard(
            title: 'تعديل الشروط',
            content: [
              'يحتفظ التطبيق بحقه في تعديل الشروط في أي وقت',
              'استمرار استخدامك للتطبيق يعني موافقتك على التحديثات',
            ],
          ),

          TermsFooterCard(),
        ],
      ),
    );
  }
}
