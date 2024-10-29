import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/upload_image_model.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/shared_widgets/buttons/customvtn.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:mihu/shared_widgets/sharePrefRepo.dart';
import 'package:sizer/sizer.dart';

import '../../shared_widgets/buttons/bottombutton.dart';
import '../profiledeatails/buisnessprofile/myDetailsModel.dart';

class Editprofile extends StatefulWidget {
  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController nameController = TextEditingController();

  final ProfileController profileController = Get.put(ProfileController());

  final LoginController loginController = Get.find<LoginController>();


  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instaController = TextEditingController();

  final TextEditingController youTubeController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController webSiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);

@override
  void initState() {
  getBusinessPostById();
    // TODO: implement initState
    super.initState();
  }

  var isLoading = false;
  var businFeilds = <MyData>[].obs;
  Future<void> getBusinessPostById() async {
    isLoading = true;
    try {
      final response = await ApiClient().getMyDetailsSignup();
      if (response['status']) {
        final businessPostModel = MyDetailsSignupModel.fromJson(response);
        businFeilds.clear();
        businFeilds.add(businessPostModel.data);
      } else {
        Get.snackbar('Error', response['message'],colorText: Colors.white,backgroundColor: Colors.black);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', e.toString(),colorText: Colors.white,backgroundColor: Colors.black);
    } finally {
      isLoading = false;
    }
  }
  bool _isSwitched = false;

int? id;
  @override
  Widget build(BuildContext context) {
    print(profileController.profileData.value);
    print(profileController.profileData.value!.whatsapp);
    print(profileController.profileData.value!.about);
    print(profileController.profileData.value!.address);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      backgroundColor: primarybackgroundColor,
      body: Obx(() {
        final profile = profileController.profileData.value;
        if (profile != null) {
          nameController.text = profile.name ?? '';
          whatsappController.text = profile.whatsapp ?? '';
          aboutController.text = profile.about ?? '';
          instaController.text = profile.instagram ?? '';
          twitterController.text = profile.twitter ?? '';
          youTubeController.text = profile.youtube ?? '';
          id=profile.id;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image picker widget
                GestureDetector(
                  onTap: () async {
                    // Picking image from gallery
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      selectedImage.value = File(pickedFile.path);
                    }
                  },
                  child: Obx(() {
                    // If image is selected, show it, otherwise show placeholder
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: selectedImage.value != null
                          ? FileImage(selectedImage.value!)
                          : NetworkImage(profile?.profilePic ??
                                  'https://via.placeholder.com/150') // Placeholder
                              as ImageProvider,
                    );
                  }),
                ),
                SizedBox(height: 2.h),
            
                // Name input field
                NameInput(
                  controller: nameController,
                  labelText: "Name",
                  hintText: "Enter your name",
                ),
                SizedBox(height: 2.h),
            
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Add more details ',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                          _isSwitched = value;
                          print(_isSwitched);
                          // Update the state
                        setState(() {});
                      },
                  trackOutlineColor: MaterialStateProperty. resolveWith<Color?>((Set<MaterialState> states) {
                    if (states. contains(MaterialState. disabled)) {
                      return Colors. orange;
                    }
                    return null; // Use the default color.
                  }),
                      activeColor: Colors.green, // Color when switch is ON
                      inactiveThumbColor:
                      Colors.blue, // Color when switch is OFF
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Obx(() {
                  if (businFeilds.isNotEmpty) {
                    final mySelfData = businFeilds.first.mySelf;
            
                    return _isSwitched
                        ? Column(
                      children: [
                        if (mySelfData.whatsapp)
                          SizedBox(height: 5.h),
                        NameInput(
                          labelText: "Whatsapp Number",
                          hintText: "Enter Whatsapp Number",
                          controller: whatsappController,
                          maxLength: 10,
                          keyboard: TextInputType.phone,
                        ),
            
                        /*  if (mySelfData.)
            
                                NameInput(
                                  labelText: "Address",
                                  hintText: "Enter Address",
                                  controller: addressController,
            
                                ),*/
            
                        if (mySelfData.insta)
                          NameInput(
                            labelText: "Instagram",
                            hintText: "Enter Instagram",
                            controller: instaController,
                          ),
                        if (mySelfData.twitter)
                          NameInput(
                            labelText: "Twitter",
                            hintText: "Enter Twitter",
                            controller: twitterController,
                          ),
            
                        if (mySelfData.youtube)
                          NameInput(
                            labelText: "Youtube",
                            hintText: "Enter Youtube",
                            controller: youTubeController,
                          ),
            
                        if (mySelfData.about)
                          NameInput(
                            labelText: "About",
                            hintText: "Enter About",
                            controller: aboutController,
                          ),
                        // Add similar checks for other fields like insta, twitter, etc.
                      ],
                    )
                        : SizedBox();
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
                SizedBox(height: 4.h),
            
                // Submit button
                Container(
                    height: 85,
                    child: BottomButton(
                      color: primarybuttonColor,
                      text: "Update",
                      onTap: () async {
                        print(  profile!.id);
                        // if (selectedImage.value != null) {
                          await uploadImg(
                          id.toString(),
                            selectedImage.value,
                            nameController.text,
                            whatsappController.text,
                            instaController.text,
                            youTubeController.text,
                            twitterController.text,
                            aboutController.text,);
                        // }else{
                        //   Fluttertoast.showToast(msg: "Please select profile pic first",backgroundColor: Colors.black,textColor: Colors.white);
                        // }
                      },
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }

  String? userprofileImage;

  // Multipart request to upload image
  uploadImg(
      String id,
      File? image,
      String name,
      String whatsapp,
      String insta,
      String youtube,
      String twitter,
      String about,
      ) async {
    String? email = await SharePref.getEmailId();
    String? phone = await SharePref.getUserMobile();

    UploadImgResponseModel? response = await ApiClient.uploadImg(
      id: id,
      imgPath: image?.path,
      email: email ?? "",  // Replace with actual email
      phone: phone ?? "",  // Replace with actual phone number
      name: name.isNotEmpty ? name : 'User Name',
      userType: 'My Self',
      about: aboutController.text,
      address: addressController.text,
      whatsapp: whatsappController.text,
      insta: instaController.text,
      twitter: twitterController.text,
      website: webSiteController.text,
    );

    if (response != null) {
      if (response.status == true) {
        Fluttertoast.showToast(msg: response.message ?? 'Profile updated successfully!');

        // Optionally, fetch updated profile data and update the UI
          // Trigger any profile data fetching or state changes
          profileController.fetchProfile();

        // Navigate to homepage or refresh UI
        Get.offAll(() => HomePage());
      } else {
        // Handle cases where status is false
        Fluttertoast.showToast(msg: response.message ?? 'Failed to update profile.');
      }
    } else {
      Fluttertoast.showToast(msg: 'Error updating profile. Please try again.');
    }
  }

}
