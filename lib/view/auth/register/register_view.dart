import 'package:app/view/auth/login/login_view.dart';
import 'package:flutter/material.dart';

/// Compatibility for old links: registration now uses the unified phone view.
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) => const LoginView();
}
