
import 'package:Naqla/helper/models/users.dart';
import 'package:Naqla/helper/service/auth_methods.dart';
import 'package:Naqla/helper/service/users_methods.dart';
import 'package:get/get.dart';


class ProfileCtrl extends GetxController {
  final _authRepo = Get.put(AuthMethods());
  final _userRepo = Get.put(UsersMethods());

  getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("error", "please login first");
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.allUser();
  }
}
