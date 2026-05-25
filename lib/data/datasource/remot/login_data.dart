import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  Future<Object> loginData(String email , String phoneNumber) async {
    var response = await crud
        .postData(ApiLinks.login, {"name": email, "phone_number": phoneNumber});
    return response.fold((l) => l, (r) => r);
  }
}
