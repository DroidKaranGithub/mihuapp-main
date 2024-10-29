import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoginForm = true.obs;

  void toggleForm() {
    isLoginForm.value = !isLoginForm.value;
  }
}
