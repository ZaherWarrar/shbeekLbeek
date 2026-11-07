import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';
import 'package:app/data/datasource/model/auth_reply.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  Future<AuthReply> loginData(String phoneNumber) =>
      crud.loginMultipart(ApiLinks.login, phoneNumber);
}
