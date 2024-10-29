import 'package:get/get.dart';

class ProfileDetailsController extends GetxController {
  var isWhatsappEnabled = false.obs;

  void toggleWhatsapp(bool value) {
    isWhatsappEnabled.value = value;
  }
}
