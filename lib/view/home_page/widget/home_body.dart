import 'package:app/view/home_page/widget/custom_home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomDeliveryAppBar());
  }
}
