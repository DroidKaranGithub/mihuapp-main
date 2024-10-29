
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/add-business_user/add_business_screen.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/home-flow/add_user/add_user_screen.dart';

import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/shared_widgets/sharePrefRepo.dart';

import 'package:sizer/sizer.dart';

class HomeSliderController extends GetxController {
  var selectedIndex = 0.obs;
  int totalMyself = 0;
  int totalBusiness = 0;

  void changeIndex(int index) {
    if(index == 1){
      if(totalBusiness == 0){
        // showBusinessProfileDialog(Get.context!,dismissible: false,);
      }else if(totalMyself==0){
        // showProfileDialog(Get.context!,dismissible: false,);
      }
    }
    selectedIndex.value = index;
  }

  getProfileDialog(BuildContext context)async{
    final response = await ApiClient().getProfile();
    if (response['status'] == true) {
      totalMyself = int.tryParse(response['data']?['total_my_self_profile'].toString() ?? "") ?? 0;
      totalBusiness = int.tryParse(response['data']?['total_business_profile'].toString() ?? "") ?? 0;
      update();
      if(totalMyself == 0){
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black.withOpacity(0.6), ),
          // Semi-transparent overlay
          child:  Positioned.fill(

            child: AlertDialog(

              backgroundColor: Colors.white,
              title: Center(child: Text('No Profile Found',style: TextStyle(fontSize: 12.sp,fontWeight:FontWeight.w500 ),)),
              content:
              Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.add, color: Colors.grey[700]),
                    title: Text('Add New Profile'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()));
                    },
                  ),
                ],
              ),

            ),
          ),
        );
      update();
      }

      await SharePref.setEmailId(response['data']['email'].toString());
      await SharePref.setUserMobile(response['data']['phone'].toString());
      await SharePref.getUserMobile();
    }
  }

  @override
  void onInit() {
    getProfileDialog(Get.context!);
    super.onInit();
  }
}


class HomeSlider2Controller extends GetxController {
  var selectedGreetingIndex = 0.obs;

  void changeGreetingIndex(int index) {
    selectedGreetingIndex.value = index;
  }
}
void showBusinessProfileDialog(BuildContext context, {bool dismissible = true}) {
  final AddUserController addUserController = Get.put(AddUserController());

  showModalBottomSheet(
    context: context,
    isDismissible: dismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Business Profile',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Obx(() {
              if (addUserController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (addUserController.addBusinessData.value?.data == null ||
                  addUserController.addBusinessData.value!.data.isEmpty) {
                return Center(child: Text('No business profile found'));
              } else {
                final profiles = addUserController.addBusinessData.value!.data;
                final defaultProfiles = profiles.where((profile) => profile.datumDefault == 1).toList();
                final otherProfiles = profiles.where((profile) => profile.datumDefault != 1).toList();

                return Column(
                  children: [
                    // Display default profile if available
                    if (defaultProfiles.isNotEmpty)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(defaultProfiles.first.logo ?? "assets/icons/profilemain.png"),
                        ),
                        title: Text(
                          defaultProfiles.first.name ?? 'Default Business User',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Default Profile'),
                      ),
                    // List other profiles
                    if (otherProfiles.isNotEmpty)
                      Container(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: otherProfiles.length,
                          itemBuilder: (context, index) {
                            final profile = otherProfiles[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(profile.logo ?? "assets/icons/profilemain.png"),
                              ),
                              title: Text(
                                profile.name ?? 'User',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close the bottom sheet
                                addUserController.setDefaultProfile(profile.id, isBusiness: true);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              }
            }),
            Divider(),
            ListTile(
              leading: Icon(Icons.add, color: Colors.grey[700]),
              title: Text('Add Business'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBusinessScreen()));
              },
            ),
          ],
        ),
      );
    },
  );
}

// class HomeSlider2Controller extends GetxController {
//   var selectedGreetingIndex = 0.obs;
//
//   void changeGreetingIndex(int index) {
//     selectedGreetingIndex.value = index;
//   }
// }