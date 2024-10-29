import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/add-business_user/add_business_screen.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:sizer/sizer.dart';
import '../../../constrants/colors/colors.dart';
import '../../../network/apiclient.dart/apicilent.dart';
import '../../../network/models/profile_model.dart';
import '../../add_user/add_user_controller.dart';
import '../../add_user/add_user_screen.dart';

class BusinessProfileHeader extends StatefulWidget {
  @override
  State<BusinessProfileHeader> createState() => _BusinessProfileHeaderState();
}

class _BusinessProfileHeaderState extends State<BusinessProfileHeader> {
  final ProfileController profileController = Get.put(ProfileController());
  final AddUserController addUserController = Get.put(AddUserController());

  @override
  void initState() {
    super.initState();
    fetchProfiles();
    print("ProfileHeader initialized.");
  }
  Future<void> fetchProfiles() async {
    await addUserController.fetchAddUsers();

    // Filter for Business userType
    if (addUserController.addUserData.value?.data != null &&
        addUserController.addUserData.value!.data.isNotEmpty) {

      // Find business profiles
      final businessProfiles = addUserController.addUserData.value!.data
          .where((profile) => profile.userType == "Business")
          .toList();

      if (businessProfiles.isNotEmpty) {
        // Set the first business profile to the profileData
        profileController.profileData.value = Profile.fromDatum(businessProfiles.first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // try {
          //   await addUserController.fetchAddUsers();
          // } catch (e) {
          //   // Handle any critical errors here
          // }
          showProfileDialog(context); // Show the dialog after fetching profiles
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.h),
          decoration: BoxDecoration(
            color: backgroundColorWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(() {
            // Filter for Business profiles
            final profiles = addUserController.addUserData.value!.data
                .where((profile) => profile.userType == "Business")
                .toList();

            // Get the default business profile
            final defaultProfiles = profiles.where((profile) => profile.datumDefault == 1).toList();
            final otherProfiles = profiles.where((profile) => profile.datumDefault != 1).toList();

            // Determine which profile to show: default or first from otherProfiles
            final activeProfiles = defaultProfiles.isNotEmpty
                ? defaultProfiles.first  // Use the first default profile
                : (otherProfiles.isNotEmpty ? otherProfiles.first : null);

            return Row(
              children: [
                CircleAvatar(
                  radius: 33,
                  backgroundImage: activeProfiles?.profileImage != null && activeProfiles!.profileImage.isNotEmpty
                      ? NetworkImage(activeProfiles.profileImage)
                      : AssetImage('assets/icons/profilemain.png') as ImageProvider,  // Fallback image
                ),
                SizedBox(width: 2.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active My Profile',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      activeProfiles?.name ?? 'No Profile Found',
                     
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 2.h,
                  color: Colors.grey[700],
                ),
              ],
            );
          }),

        ),
      ),
    );
  }
}

void showProfileDialog(BuildContext context,{dismissible = true}) {
  final AddUserController addUserController = Get.put(AddUserController());
  final ProfileController profileController = Get.put(ProfileController());

  showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      return PopScope(
        canPop: dismissible,
        child: Dialog(
          backgroundColor: backgroundColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Profile', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                Obx(() {
                  if (addUserController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (addUserController.addUserData.value?.data == null ||
                      addUserController.addUserData.value!.data.isEmpty) {
                    return Center(child: Text('No Profile Found', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)));
                  } else {
                    // Filter profiles for userType == Business
                    final profiles = addUserController.addUserData.value!.data
                        .where((profile) => profile.userType == "Business")
                        .toList();

                    final defaultProfiles = profiles.where((profile) => profile.datumDefault == 1).toList();
                    final otherProfiles = profiles.where((profile) => profile.datumDefault != 1).toList();

                    return Column(
                      children: [
                        if (defaultProfiles.isNotEmpty)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(defaultProfiles.first.profileImage ?? "assets/icons/profilemain.png"),
                            ),
                            title: Text(defaultProfiles.first.name ?? 'Default User', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Default Profile'),
                          ),
                        if (otherProfiles.isNotEmpty)
                          Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount: otherProfiles.length,
                              itemBuilder: (context, index) {
                                final profile = otherProfiles[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(profile.profileImage ?? "assets/icons/profilemain.png"),
                                  ),
                                  title: Text(profile.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    addUserController.setDefaultProfile(profile.profileId);
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
                  title: Text('Add New Profile'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddBusinessScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}