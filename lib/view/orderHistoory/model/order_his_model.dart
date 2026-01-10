class OrderHisModel {
  final String restaurantName;
  final String status; // نشط أو مكتمل
  final DateTime date;
  final double total;

  OrderHisModel({
    required this.restaurantName,
    required this.status,
    required this.date,
    required this.total,
  });
}