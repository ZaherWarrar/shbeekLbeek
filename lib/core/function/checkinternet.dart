import 'dart:async';
import 'dart:io';

const Duration _onlineCacheTtl = Duration(seconds: 20);

DateTime? _onlineUntil;
Future<bool>? _inFlight;

/// نتيجة «متصل» تُحفظ لثوانٍ، والطلبات المتزامنة تشارك فحصًا واحدًا.
/// الفشل لا يُخزَّن حتى لا تُحجب الطلبات التالية بسبب تعثّر لحظة واحدة.
Future<bool> checkInternet() {
  final cachedUntil = _onlineUntil;
  if (cachedUntil != null && DateTime.now().isBefore(cachedUntil)) {
    return Future<bool>.value(true);
  }
  final current = _inFlight;
  if (current != null) return current;

  final flight = _lookup();
  _inFlight = flight;
  return flight.whenComplete(() {
    if (identical(_inFlight, flight)) _inFlight = null;
  });
}

Future<bool> _lookup() async {
  try {
    final result = await InternetAddress.lookup(
      'shbeeklbeek.com',
    ).timeout(const Duration(seconds: 2));
    final online = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    if (online) {
      _onlineUntil = DateTime.now().add(_onlineCacheTtl);
    }
    return online;
  } on SocketException {
    return false;
  } on TimeoutException {
    return true;
  } catch (_) {
    return false;
  }
}
