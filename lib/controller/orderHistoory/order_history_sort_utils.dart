import 'package:app/data/datasource/model/order_status.dart';

List<T> sortOrdersByStatus<T>({
  required List<T> orders,
  required OrderStatusType Function(T order) statusOf,
  required DateTime? Function(T order) dateOf,
}) {
  final sorted = List<T>.from(orders);
  sorted.sort((a, b) {
    final statusCompare =
        statusOf(a).sortPriority.compareTo(statusOf(b).sortPriority);
    if (statusCompare != 0) return statusCompare;

    final dateA = dateOf(a);
    final dateB = dateOf(b);
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;
    return dateB.compareTo(dateA);
  });
  return sorted;
}
