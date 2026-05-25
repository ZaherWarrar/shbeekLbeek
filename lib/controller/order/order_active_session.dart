import 'package:app/core/services/session_service.dart';

const int orderCancelWindowSeconds = 10 * 60;

class OrderActiveSession {
  OrderActiveSession(this.session);

  final SessionService session;

  int? orderId;
  DateTime? createdAt;

  void loadFromSession() {
    final activeOrder = session.activeOrder;
    if (activeOrder == null) return;
    orderId = activeOrder['orderId'];
    createdAt = activeOrder['createdAt'];
  }

  Future<void> persist(int id, DateTime created) async {
    orderId = id;
    createdAt = created;
    await session.saveActiveOrder(id, created);
  }

  Future<void> clear() async {
    orderId = null;
    createdAt = null;
    await session.clearActiveOrder();
  }

  bool get hasActive => session.hasActiveOrder;

  int remainingCancelSeconds() {
    if (createdAt == null) return 0;
    final elapsed = DateTime.now().difference(createdAt!).inSeconds;
    final remaining = orderCancelWindowSeconds - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  bool shouldAutoConfirm() => remainingCancelSeconds() <= 0;
}
