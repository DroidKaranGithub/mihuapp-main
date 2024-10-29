import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = Rxn<Profile>(); // Allow null values for profile
  var isDataMatched = false.obs;

  // Initialize GetStorage
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Fetch profile data when the controller is initialized
    fetchProfile();

    final storedProfile = storage.read('userProfile');
    if (storedProfile != null) {
      setProfileData(
          Profile.fromJson(storedProfile)); // Set stored profile data
    }
  }

  fetchProfile() async {
    isLoading(true);
    try {
      final profileId = ApiClient().storage?.read('profile_id');
      if (profileId == null || profileId.isEmpty) {
        // Get.snackbar('Error', 'Profile ID is not set.');
        return;
      }
      final response = await http.get(
        Uri.parse('https://mihuapp.com/api/default-profile/$profileId'),
        headers: {
          'Authorization': 'Bearer ${ApiClient().token}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          Profile fetchedProfile = Profile.fromJson(data['data']);
          profileData.value = fetchedProfile;
          compareProfileData(fetchedProfile);
        } else {
          Get.snackbar('Error', 'Failed to fetch profile data.');
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch profile data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile data. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  void compareProfileData(Profile fetchedProfile) {
    final storedData = storage.read('userProfile');
    if (storedData != null) {
      Profile loggedInProfile = Profile.fromJson(storedData);
      isDataMatched.value = (fetchedProfile.name == loggedInProfile.name &&
          fetchedProfile.profilePic == loggedInProfile.profilePic);
    } else {
      isDataMatched.value = false; // No stored data to compare
    }
  }

  void setProfileData(Profile? profile) {
    profileData.value = profile; // Update profile data, can be null
    if (profile != null) {
      storage.write('userProfile', profile.toJson()); // Update stored profile
    }
  }
}
