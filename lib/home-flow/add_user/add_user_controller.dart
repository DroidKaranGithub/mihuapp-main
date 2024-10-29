import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/home-flow/add_user/add_user_model.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:http/http.dart' as http;
import 'package:mihu/home-flow/add_user/add_user_model.dart';

import '../../network/models/profile_model.dart';
import '../add-business_user/add_business_model.dart';

class AddUserController extends GetxController {
  var isLoading = false.obs;
  var addUserData = Rxn<AddUserResponseModel>(); // Use Rxn to allow null values
  var addBusinessData = Rxn<AddBusinessDataModel>(); // Use Rxn to allow null values
  var isDataMatched = false.obs;

  // Initialize GetStorage
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAddUsers();

    final storedProfile = GetStorage().read('userProfile');
    if (storedProfile != null) {
      // setProfileData(Profile.fromJson(storedProfile));
    }
  }

  var defaultProfilesListBusiness = <DatumAddUser>[].obs;

  var defaultProfilesList = <DatumAddUser>[].obs;
  var defaultProfiles = <Profile>[].obs;
  Future<void> fetchAddUsers() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('https://mihuapp.com/api/user-profile'),
        headers: {
          'Authorization': 'Bearer ${ApiClient().token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          AddUserResponseModel fetchedProfile = AddUserResponseModel.fromJson(data);
          addUserData.value = fetchedProfile;

          // Populate defaultProfilesList with profiles marked as default
          defaultProfilesList.value = fetchedProfile.data
              .where((profile) => profile.userType == "My Self" && profile.datumDefault == 1)
              .toList();
          update();
          print(defaultProfilesList);
        } else {
          throw Exception('Failed to fetch profile data');
        }
        update();
      } else {
        throw Exception('Failed to fetch profile data');
      }
      update();
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading(false);
    }
    update();
  }


  fetchAdBusiness() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('https://mihuapp.com/api/business-list'),
        headers: {
          'Authorization': 'Bearer ${ApiClient().token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status']) {
          // Check if 'data' is a list or a map
          if (data['data'] is List) {
            // Parse as a list of Datum objects
            AddBusinessDataModel fetchedProfile = AddBusinessDataModel.fromJson(data);
            addBusinessData.value = fetchedProfile;
            update();

          } else if (data['data'] is Map) {
            // If 'data' is a map, wrap it in a list
            List<Map<String, dynamic>> wrappedData = [data['data']];
            AddBusinessDataModel fetchedProfile = AddBusinessDataModel.fromJson({
              "status": data['status'],
              "message": data['message'],
              "data": wrappedData,
            });
            addBusinessData.value = fetchedProfile;
            update();

            print("addedUserList");
            print(fetchedProfile);
          } else {
            print('Unexpected data format');
          }
          try {
            SliderController ctrl = Get.find();
            ctrl.isPostLoading.value = true;
            ctrl.isPostLoading.value = false;
          } catch (e){}
        } else {
          throw Exception('Failed to fetch profile data');
        }
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (e, s) {
      print('Error fetching profile: $e');
      print('Stack trace: $s');
    } finally {
      isLoading(false);
    }
    update();

  }

  void compareAddUserData(AddUserResponseModel fetchedProfile) {
    final storedData = storage.read('userProfile');
    if (storedData != null) {
      AddUserResponseModel loggedInProfile = AddUserResponseModel.fromJson(storedData);
      isDataMatched.value = (fetchedProfile.data == loggedInProfile.data &&
          fetchedProfile.data == loggedInProfile.data);
      update();

    } else {
      isDataMatched.value = false;
    }
    update();

  }

  Future setDefaultProfile(id,{bool isBusiness = false}) async {
    final response = await http.get(
      Uri.parse(isBusiness ? 'https://mihuapp.com/api/default-business/$id' : 'https://mihuapp.com/api/default-profile/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );

    if (response.statusCode == 200) {
      isBusiness ? fetchAdBusiness() : fetchAddUsers();
      update();
    }
    update();

  }

}
