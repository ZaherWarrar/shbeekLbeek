import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class RegisterData {
  Crud crud;

  RegisterData(this.crud);

  Future<Object> registerData(String name,  String phoneNumber) async {
    var response = await crud
        .postData(ApiLinks.createAccount, {"name": name, "phone_number": phoneNumber});
    return response.fold((l) => l, (r) => r);
  }
}
