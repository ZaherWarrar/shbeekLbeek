import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  loginData(String email, String password , String phoneNumber) async {
    var response = await crud
        .postData(ApiLinks.login, {"name": email, "phone_number": phoneNumber, "password": password});
    return response.fold((l) => l, (r) => r);
  }
}
