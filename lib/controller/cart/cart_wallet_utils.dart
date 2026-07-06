double calculateWalletDeduction({
  required bool useWallet,
  required int walletBalance,
  required double amountBeforeWallet,
}) {
  if (!useWallet || walletBalance <= 0 || amountBeforeWallet <= 0) {
    return 0.0;
  }

  final balance = walletBalance.toDouble();
  return balance >= amountBeforeWallet ? amountBeforeWallet : balance;
}
