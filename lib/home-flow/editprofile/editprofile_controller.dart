import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = Rxn<Profile>(); // Use Rxn to allow null values
  var isDataMatched = false.obs;
  Map<String,dynamic> mySelfKeys = {};
  Map<String,dynamic> businessKeys = {};

  // Initialize GetStorage
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();

    final storedProfile = GetStorage().read('userProfile');
    if (storedProfile != null) {
      setProfileData(Profile.fromJson(storedProfile));
    }
  }

  fetchProfile(
      // String? profileId
      ) async {
    isLoading(true);
    try {
      final response2 = await http.get(
        Uri.parse('https://mihuapp.com/api/user-profile'),
        headers: {
          'Authorization': 'Bearer ${ApiClient().token}',
        },
      );

      if (response2.statusCode == 200) {
        final data = json.decode(response2.body);
        if (data['status']) {
          List profileList = data['data'];
          var lst = profileList.where((element) => element['default'] == 1,);
          if(lst.isNotEmpty){
            ApiClient().storage?.write('profile_id',lst.first['profile_id']);
          }
          final response = await http.get(
            Uri.parse('https://mihuapp.com/api/default-profile/${ApiClient().storage?.read('profile_id')}'),
            headers: {
              'Authorization': 'Bearer ${ApiClient().token}',
            },
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            getFieldStatus();
            if (data['status']) {
              Profile fetchedProfile = Profile.fromJson(data['data']);
              profileData.value = fetchedProfile;
              print("getProfile");
              compareProfileData(fetchedProfile);
            } else {
              throw Exception('Failed to fetch profile data');
            }
          } else {
            throw Exception('Failed to fetch profile data');
          }
        } else {
          throw Exception('Failed to fetch profile data');
        }
      } else {
        throw Exception('Failed to fetch profile data');
      }

    } catch (e,s) {
      print('Error fetching profile: $e');
    } finally {
      isLoading(false);
    }
  }

  getFieldStatus()async{
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/field-status'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      mySelfKeys = data['data']['my_self'];
      businessKeys = data['data']['business'];
    }
  }

  void compareProfileData(Profile fetchedProfile) {
    final storedData = storage.read('userProfile');
    if (storedData != null) {
      Profile loggedInProfile = Profile.fromJson(storedData);
      isDataMatched.value = (fetchedProfile.name == loggedInProfile.name &&
          fetchedProfile.profilePic == loggedInProfile.profilePic);
    } else {
      isDataMatched.value = false;
    }
  }

  void setProfileData(Profile? profile) {
    profileData.value = profile; // profile can be null
  }
}
