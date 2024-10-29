import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/editprofile/editprofile.dart';
import 'package:mihu/home-flow/home/controller/home_data_controller.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/home-flow/profile/elements/editpassword.dart';
import 'package:mihu/home-flow/profile/screens/privacy_policy_screen.dart';
import 'package:mihu/home-flow/profile/screens/terms_services_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth_workflow/screens/login_signup.dart';
import '../../../welcome_workflow/screen/welcome.dart';
import '../../add_user/add_user_controller.dart';
import 'package:http/http.dart'as http;
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController profileController3 = Get.put(ProfileController());
  final HomeDataController homeDataController = Get.put(HomeDataController());
  final LoginController loginController = Get.find<LoginController>();

  getUserImage() {
    final profileData = profileController3.profileData.value;

    log('Current logged in user (which is in profile API) image is showing');
    return profileData?.profilePic != null &&
            profileData!.profilePic!.isNotEmpty
        ? Container(
            height: 95,
            width: 95,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(profileData.profilePic.toString()),
                    fit: BoxFit.cover)),
          )
        : Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/icons/profilemain.png"),
                    fit: BoxFit.cover)),
          );
  }

  getUserName() {
    final profileData = profileController3.profileData.value;
    if (profileController3.isDataMatched.value) {
      return Text(
        profileData?.name ?? 'User',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        loginController.storage.read('name') ?? 'User',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Obx(() {
                  if (profileController3.isLoading.value ||
                      loginController.isLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 2.h),
                        _buildDefaultProfile(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 2.h),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await shareAppImage(context);
                                },
                                icon: Icon(Icons.share, color: Colors.white),
                                label: Text(
                                  'Share This App',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2C3E50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.w),
                                child: Column(
                                  children: [
                                    _buildSettingItem(
                                        'assets/icons/edit.png', 'Edit Profile',
                                        () {
                                      Get.to(Editprofile());
                                    }),
                                    SizedBox(height: 1.h),
                                    _buildSettingItem(
                                        'assets/icons/lock_icon.png',
                                        'Password', () {
                                      Get.to(EditPassword());
                                    }),
                                    SizedBox(height: 1.h),
                                    SettingsToggle(
                                      iconPath:
                                          'assets/icons/notifications_icon.png',
                                      title: 'Notifications',
                                      initialValue: true,
                                      onChanged: (value) {
                                        // Handle the toggle change here
                                      },
                                    ),
                                    SizedBox(height: 1.h),
                                    _buildSettingItem(
                                        'assets/icons/log.png', 'Logout',
                                        () async {
                                          showAlertDialog(context);

                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialIcon('assets/icons/linkedin.png',
                                      Uri.parse('https://www.linkedin.com')),
                                  _buildSocialIcon('assets/icons/facebook.png',
                                      Uri.parse('https://www.facebook.com')),
                                  _buildSocialIcon('assets/icons/instagram.png',
                                      Uri.parse('https://www.instagram.com')),
                                  _buildSocialIcon('assets/icons/twitter.png',
                                      Uri.parse('https://www.twitter.com')),
                                ],
                              ),
                              SizedBox(height: 0.9.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => TermsServicesScreen());
                                    },
                                    child: Text(
                                      'Terms & Service',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => PrivacyPolicyScreen());
                                    },
                                    child: Text(
                                      'Privacy Policy',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context) {
    final storage = GetStorage();
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel",style: TextStyle(color: Colors.black),),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue",style: TextStyle(color: Colors.blue),),
      onPressed:  () async {
        ApiClient().logout();        // Get.offAll(LoginSignup());
        SharedPreferences prefrences = await SharedPreferences.getInstance();
        await prefrences.clear();
        await storage.erase();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget _buildDefaultProfile() {
    return Obx(() {
      final selectedProfile = profileController3
          .profileData.value; // Get the currently selected profile

      if (profileController3.isLoading.value) {
        return CircularProgressIndicator();
      } else if (selectedProfile == null) {
        return Center(
          child: Text('No Default Profile Found',
              style: TextStyle(fontSize: 14.sp)),
        );
      } else {
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(selectedProfile.profilePic ??
                      'https://via.placeholder.com/150') // Placeholder
                  as ImageProvider,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              selectedProfile.name ?? "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ],
        );
      }
    });
  }

  Future<void> shareAppImage(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/your_image.png'; // Your image path

      final file = XFile(imagePath);
      // Optionally create a dummy image file if needed
      // await file.writeAsBytes(<int>[]); // Add your actual image data here

      // Share the image using Share
      // await Share.shareXFiles([file], text: 'Check out this image!');
    } catch (e) {
      print('Error sharing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image.'),),
      );
    }
  }

  Widget _buildSettingItem(String iconPath, String title, VoidCallback onTap) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(4),
                child: Image.asset(
                  iconPath,
                  width: 6.w,
                  height: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String iconPath, Uri url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        child: Image.asset(
          iconPath,
          width: 8.w,
          height: 8.w,
        ),
      ),
    );
  }
}

class SettingsToggle extends StatefulWidget {
  final String iconPath;
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SettingsToggleState createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<SettingsToggle> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue; // Set the initial value
  }

  void _handleToggle(bool value) {
      _isToggled = value; // Update the local state
    widget.onChanged(value); // Call the parent callback
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                widget.iconPath,
                width: 6.w,
                height: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            Switch(
              value: _isToggled,
              onChanged: _handleToggle,
            ),
          ],
        ),
      ),
    );
  }
}
