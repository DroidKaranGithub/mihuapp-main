import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/network/models/profile_model.dart';

class LoginStateController extends GetxController {
  // var profileData = Profile().obs;

  @override
  void onInit() {
    super.onInit();
    if (GetStorage().read('userProfile') != null) {
      setProfileData(Profile.fromJson(GetStorage().read('userProfile')));
    }
  }

  void setProfileData(Profile data) {
    // profileData.value = data;
  }
}
