import 'package:app/core/constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthColors {
  static const purple = Color(0xFF5C2A86);
  static const purpleText = Color(0xFF3D215C);
  static const yellow = Color(0xFFFFC107);
  static const hint = Color(0xFFB0B0B0);
  static const label = Color(0xFF2A2433);
  static const fieldBorder = Color(0xFFE6E1EC);
}

class AuthMetrics {
  static bool isCompactHeight(double height) => height < 600;

  static double gap(BuildContext context, double value) {
    final height = MediaQuery.sizeOf(context).height;
    if (!isCompactHeight(height)) return value;
    return value * (height / 600).clamp(0.7, 1);
  }

  static double cardMargin(double height, double keyboard) {
    final available = height - keyboard;
    if (!isCompactHeight(available)) return 70;
    if (available <= 420) return 8;
    return 8 + (70 - 8) * ((available - 420) / (600 - 420));
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MediaQuery(
        data: media.copyWith(
          textScaler: media.textScaler.clamp(
            minScaleFactor: 1,
            maxScaleFactor: 1.35,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final topInset = MediaQuery.paddingOf(context).top;
              final keyboard = MediaQuery.viewInsetsOf(context).bottom;
              final height = constraints.maxHeight;
              final compact = AuthMetrics.isCompactHeight(height);
              final logoHeight = compact
                  ? (height * 0.12).clamp(52.0, 84.0)
                  : (height * 0.16).clamp(96.0, 160.0);
              final logoTop = compact ? topInset + 8 : topInset * 0.45 + 28;
              final side = constraints.maxWidth < 340 ? 16.0 : 22.0;
              final bottomSafe = compact
                  ? MediaQuery.paddingOf(context).bottom
                  : 0.0;

              return Stack(
                fit: StackFit.expand,
                children: [
                  const Image(
                    image: AssetImage(Assets.imagesAuthBack),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Positioned(
                    top: logoTop,
                    left: side,
                    right: side,
                    height: logoHeight,
                    child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
                  ),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        side,
                        logoTop + logoHeight + (compact ? 4 : 8),
                        side,
                        24 + keyboard + bottomSafe,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final margin = AuthMetrics.cardMargin(height, keyboard);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: margin, bottom: keyboard > 0 ? 12 : 0),
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AuthColors.purple.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.errorText,
    this.maxLength,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onChanged;
  final String? errorText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AuthColors.label,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          maxLength: maxLength,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AuthColors.purpleText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: const TextStyle(
              color: AuthColors.hint,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: Icon(icon, color: AuthColors.purple),
            border: _border(AuthColors.fieldBorder),
            enabledBorder: _border(AuthColors.fieldBorder),
            focusedBorder: _border(AuthColors.purple),
            errorBorder: _border(Colors.red.shade400),
            focusedErrorBorder: _border(Colors.red.shade400),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
    this.enabled = true,
  });

  final String title;
  final VoidCallback? onTap;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !loading;
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: canTap ? onTap : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AuthColors.yellow,
          disabledBackgroundColor: AuthColors.yellow.withValues(alpha: 0.55),
          foregroundColor: AuthColors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AuthColors.purple,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AuthColors.purple,
                  ),
                ),
              ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  const AuthOutlineButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthColors.purple,
          side: const BorderSide(color: AuthColors.purple, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
