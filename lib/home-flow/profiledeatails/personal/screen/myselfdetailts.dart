/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/home-flow/profiledeatails/personal/controller/profiledetailscontroller.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:mihu/shared_widgets/uploadphoto/uploadphoto.dart';
import 'package:sizer/sizer.dart';

import '../element/whatsapptoggle.dart';

class MyDetailsPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileDetailsController = Get.find<ProfileDetailsController>();

    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    const UploadPhoto(),
                    SizedBox(height: 2.h),
                    NameInput(
                      controller: nameController,
                      labelText: "Name",
                      hintText: "Enter your name",
                    ),
                    SizedBox(height: 2.h),
                    const DetailsToggle(), // Assuming this is a toggle for some settings
                    SizedBox(height: 1.h),
                    Obx(() {
                      if (profileDetailsController.isWhatsappEnabled.value) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/whatsapp.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                const Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
                            TextField(
                              controller: whatsappController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Enter Mobile Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox(); // Return an empty widget if no fields should be shown
                    }),
                  ],
                ),
              ),
            ),
            BottomButton(
              color: primarybuttonColor,
              text: "Next",
              onTap: () {
                Get.to(HomePage());
              },
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/profiledeatails/buisnessprofile/myDetailsModel.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:sizer/sizer.dart';

import '../../../../network/models/upload_image_model.dart';
import '../../../buisness_personal/controllers/selectioncontroller.dart';
import '../../../home/screen/homescreen.dart';
import '../../../profile/controller/profile_controller.dart';

class MyDetailsPage extends StatefulWidget {
  MyDetailsPage({super.key});

  @override
  State<MyDetailsPage> createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instaController = TextEditingController();

  final TextEditingController youTubeController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController webSiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final storage = GetStorage();

  var isLoading = false;
  var businFeilds = <MyData>[].obs;
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    getBusinessPostById();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    GestureDetector(
                      onTap: () async {
                        // Picking image from gallery
                        final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery);
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
                              : NetworkImage(
                                      'https://via.placeholder.com/150') // Placeholder
                                  as ImageProvider,
                        );
                      }),
                    ),
                    SizedBox(height: 5.h),
                    NameInput(
                      labelText: "Name",
                      hintText: "Enter Name",
                      controller: nameController,
                    ),
                    SizedBox(height: 3.h),
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
                            setState(() {
                              _isSwitched = value;
                              print(_isSwitched);
                              // Update the state
                            });
                          },
                          activeColor: Colors.green, // Color when switch is ON
                          inactiveThumbColor:
                              Colors.red, // Color when switch is OFF
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
                  ],
                ),
              ),
            ),
            BottomButton(
              color: primarybuttonColor,
              text: "Next",
              onTap: () async {
                // if (selectedImage.value != null) {
                  await uploadImg(
                    selectedImage.value,
                    nameController.text,
                    whatsappController.text,
                    instaController.text,
                    youTubeController.text,
                    twitterController.text,
                    aboutController.text,
                  );
                // } else {
                //   FlutterError("Please add image");
                // }

                // Get.to(HomePage());
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  final SelectionController controller = Get.put(SelectionController());
  final ProfileController profileController = Get.put(ProfileController());

  uploadImg(
    File? image,
    String name,
    String whatsaap,
    String insta,
    String youtube,
    String twitter,
    String about,
  ) async {
    UploadImgResponseModel? response = await ApiClient.uploadImgSignup(
      imgPath: image?.path ,
      // email: 'user@gmail.com',
      // phone: '1234567890',
      name: name ?? 'User Name',
      // whatsaap:"",
      userType: controller.userType ?? 'My Self',
      about: aboutController.text,
      address: addressController.text,
      whatsapp: whatsappController.text,
      insta: instaController.text,
      twitter: twitterController.text,
      website: webSiteController.text,
    );

    if (response != null) {
      print("status");
      print(response.status);
      if (response.status == true) {
        setState(() {
          // Trigger any profile data fetching or state changes
          profileController.fetchProfile();
        });



        Get.offAll(() => HomePage());
        // Get.to(HomePage());
      }

      // LoginResponseModel userData = await SessionManager().getUserData();

      // userData.data!.user?.isProfileImage = response.data.toString();

      // await SessionManager().saveUserData(userData);
      // await SessionManager().setUserLoggedIn(true);
      setState(() {
        // userprofileImage = response.data!.profileImage;
      });
      // Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => DashboardScreen(currentTabIndexF: 0,)), (route) => false,);
    }

    // setState(() {
    //   isLoading = false;
    // });
  }
}

class WhatsAppToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: true,
            onChanged: (value) {
              // Handle checkbox state
            }),
        Text('Enable WhatsApp'),
      ],
    );
  }
}
