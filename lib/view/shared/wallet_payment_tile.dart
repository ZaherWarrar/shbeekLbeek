import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class WalletPaymentTile extends StatelessWidget {
  const WalletPaymentTile({
    super.key,
    required this.useWallet,
    required this.canUseWallet,
    required this.isLoggedIn,
    required this.isLoading,
    required this.statusMessage,
    required this.walletBalance,
    required this.onToggle,
    this.onLogin,
  });

  final bool useWallet;
  final bool canUseWallet;
  final bool isLoggedIn;
  final bool isLoading;
  final String statusMessage;
  final int walletBalance;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: useWallet ? AppColor().primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColor().primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColor().primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استخدام المحفظة',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                if (isLoading)
                  Text(
                    'جاري تحميل الرصيد...',
                    style: TextStyle(
                      color: AppColor().descriptionColor,
                      fontSize: 12,
                    ),
                  )
                else if (!canUseWallet)
                  Text(
                    statusMessage,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  )
                else
                  Text(
                    'الرصيد المتاح: $walletBalance ل.س',
                    style: TextStyle(
                      color: AppColor().descriptionColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (canUseWallet)
            Switch.adaptive(
              value: useWallet,
              activeTrackColor: AppColor().primaryColor.withValues(alpha: 0.5),
              activeThumbColor: AppColor().primaryColor,
              onChanged: onToggle,
            )
          else if (!isLoggedIn && onLogin != null)
            TextButton(
              onPressed: onLogin,
              child: Text(
                'دخول',
                style: TextStyle(color: AppColor().primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
