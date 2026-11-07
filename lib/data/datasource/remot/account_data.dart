import 'package:app/core/class/crud.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/link_api.dart';

class AccountResult {
  const AccountResult({this.savedName, this.deleted = false, this.error});
  final String? savedName;
  final bool deleted;
  final String? error;
}

class AccountData {
  AccountData(this.crud, this.session);
  final Crud crud;
  final SessionService session;

  Future<AccountResult> saveName(String name) async {
    final reply = await crud.accountRequest(
      'PUT',
      ApiLinks.userProfile,
      headers: session.headers,
      body: {'name': name},
    );
    if (reply.statusCode == 200 &&
        reply.json?['success'] != false &&
        reply.json?['status'] != false &&
        reply.json?['error'] == null) {
      // Only a returned account name confirms persistence. A message alone,
      // HTML, an empty response, or a local flag cannot complete the profile.
      final user = reply.json?['user'];
      final returnedId = user is Map ? user['id'] : reply.json?['id'];
      if (returnedId != null && returnedId.toString() != session.userId) {
        return const AccountResult(
          error: 'لم يؤكد الخادم بيانات الحساب الحالي.',
        );
      }
      final returned = user is Map ? user['name'] : reply.json?['name'];
      if (returned is String && returned.trim() == name) {
        return AccountResult(savedName: returned.trim());
      }
    }
    return AccountResult(
      error:
          reply.errorMessage ??
          'لم يؤكد الخادم حفظ الاسم. أعد المحاولة أو تواصل مع الدعم.',
    );
  }

  Future<AccountResult> deleteAccount() async {
    final reply = await crud.accountRequest(
      'DELETE',
      ApiLinks.userAccount,
      headers: session.headers,
    );
    // 204 is an unambiguous HTTP acknowledgement with no representation.
    // No JSON success envelope for 200/202 is documented in this repository.
    if (reply.statusCode == 204) return const AccountResult(deleted: true);
    return AccountResult(
      error:
          reply.errorMessage ??
          'تعذر تأكيد حذف الحساب. تواصل مع الدعم قبل إعادة المحاولة.',
    );
  }
}
