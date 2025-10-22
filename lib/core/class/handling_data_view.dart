import 'package:app/core/class/statusrequest.dart';
import 'package:flutter/widgets.dart';

class HandlingDataView extends StatelessWidget {
  const HandlingDataView(
      {super.key, required this.statusRequest, required this.widget});
  final StatusRequest statusRequest;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("data"),
    );
  }
}
