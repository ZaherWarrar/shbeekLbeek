class PaymentMethod {
  PaymentMethod._();

  static const String cod = 'COD';
  static const String wallet = 'wallet';

  static String fromUseWallet(bool useWallet) =>
      useWallet ? wallet : cod;
}
