import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/account_data.dart';
import 'package:get/get.dart';

/// UI-independent orchestration so tests cannot contact a real server.
class AccountController extends GetxController {
  AccountController({
    required this.session,
    required this.data,
    required this.showNameGate,
    required this.confirmDeletion,
    required this.clearLocalAccount,
    required this.unlinkNotifications,
    required this.goToLogin,
    required this.refreshProfile,
  });

  final SessionService session;
  final AccountData data;
  final Future<void> Function() showNameGate;
  final Future<bool> Function() confirmDeletion;
  final Future<void> Function() clearLocalAccount;
  final Future<void> Function() unlinkNotifications;
  final Future<void> Function() goToLogin;
  final void Function() refreshProfile;

  bool savingName = false;
  bool deleting = false;
  bool leaving = false;
  bool _gateOpen = false;
  bool _deleteFlowOpen = false;
  String? nameError;
  String? deleteError;

  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'الرجاء إدخال الاسم';
    if (name.runes.length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  @override
  void onReady() {
    super.onReady();
    if (session.isLoggedIn) ensureName();
  }

  Future<bool> ensureName() async {
    if (!session.isLoggedIn || session.isGuest || leaving || deleting) {
      return false;
    }
    if (session.hasCompletedName) return true;
    if (!_gateOpen) {
      _gateOpen = true;
      nameError = null;
      try {
        await showNameGate();
      } finally {
        _gateOpen = false;
      }
    }
    return session.isLoggedIn && session.hasCompletedName && !leaving;
  }

  Future<bool> saveName(String input) async {
    if (savingName || leaving || !session.isLoggedIn) return false;
    if (session.hasCompletedName) return true;
    // A malformed user object must not overwrite an existing account name.
    if (!session.isNameKnown) {
      nameError =
          'تعذر معرفة اسم الحساب من استجابة الخادم. سجّل الدخول مجدداً أو تواصل مع الدعم.';
      update();
      return false;
    }
    nameError = validateName(input);
    if (nameError != null) {
      update();
      return false;
    }
    savingName = true;
    update();
    final token = session.token;
    try {
      final result = await data.saveName(input.trim());
      if (session.token != token || leaving) return false;
      if (result.savedName == null) {
        nameError = result.error ?? 'تعذر حفظ الاسم. أعد المحاولة.';
        return false;
      }
      await session.saveVerifiedName(result.savedName);
      refreshProfile();
      return true;
    } catch (_) {
      nameError = 'تعذر حفظ الاسم. تحقق من الاتصال وأعد المحاولة.';
      return false;
    } finally {
      savingName = false;
      update();
    }
  }

  Future<bool> requestDeletion() async {
    if (_deleteFlowOpen || deleting || leaving || !session.isLoggedIn) {
      return false;
    }
    _deleteFlowOpen = true;
    deleteError = null;
    final token = session.token;
    try {
      if (!await confirmDeletion()) return false;
      if (session.token != token) return false;
      return await deleteConfirmed();
    } finally {
      _deleteFlowOpen = false;
    }
  }

  Future<bool> deleteConfirmed() async {
    if (deleting || leaving || !session.isLoggedIn) return false;
    deleting = true;
    deleteError = null;
    update();
    final token = session.token;
    try {
      final result = await data.deleteAccount();
      if (session.token != token) {
        deleteError = result.error;
        return false;
      }
      if (!result.deleted) {
        deleteError = result.error ?? 'تعذر حذف الحساب. أعد المحاولة.';
        return false;
      }
      await leaveAccount();
      return true;
    } catch (_) {
      deleteError = 'تعذر تأكيد حذف الحساب. تحقق من الاتصال وأعد المحاولة.';
      return false;
    } finally {
      deleting = false;
      update();
    }
  }

  Future<void> leaveAccount() async {
    if (leaving) return;
    leaving = true;
    update();
    try {
      // Best effort only, including after deletion invalidates the token.
      try {
        await unlinkNotifications().timeout(const Duration(seconds: 3));
      } catch (_) {}
      await session.clearAccountData();
      await clearLocalAccount();
      refreshProfile();
      await goToLogin();
    } finally {
      leaving = false;
      update();
    }
  }
}
