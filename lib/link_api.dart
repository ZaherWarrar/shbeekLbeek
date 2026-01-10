class ApiLinks {
  // Base URL
  static const String baseUrl = 'https://shbeeklbeek.com/new/index.php/api';
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
}
