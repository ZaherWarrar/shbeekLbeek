class PaymentMethodModel {
  final String id;
  final String title;
  final String icon;
  final bool isOnline;

  PaymentMethodModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.isOnline,
  });
}
