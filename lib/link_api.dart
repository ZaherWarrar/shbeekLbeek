class ApiLinks {
  // Base URL
  // static const String baseUrl = 'https://shbeeklbeek.com/new/index.php/api';
  static const String baseUrl =
      'https://shbeeklbeek.com/shbeeklbeek_back/public/api';
  // Authentication Endpoints
  static const String login = '$baseUrl/login';
  static const String createAccount = '$baseUrl/register';
  static const String verifyCode = '$baseUrl/verify';
  // home page Endpoints
  static const String home = '$baseUrl/home/';
  // Order Endpoints
  static const String createOrder = '$baseUrl/order';
  static const String confirmOrder = '$baseUrl/order/confirm';
  static const String cancelOrder = '$baseUrl/order/cancel';
  static const String coupons = '$baseUrl/coupons/available';
  static const String couponCheck = '$baseUrl/coupons/check/';
  static const String myOrders = '$baseUrl/my_order';
  static const String addFavorite = '$baseUrl/favorites';
  static const String store = '$baseUrl/store';
  static const String productDetails = '$baseUrl/products';
  static const String productRecommended = '$baseUrl/products/recomended';
}
