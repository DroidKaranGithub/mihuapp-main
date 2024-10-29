import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/home-flow/home/elements/business_home.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:sizer/sizer.dart';

import '../../constrants/colors/colors.dart';
import '../../network/apiclient.dart/apicilent.dart';
import '../../shared_widgets/buttons/bottombutton.dart';
import '../home/controller/home_slider_controller.dart';
import '../profiledeatails/buisnessprofile/myDetailsModel.dart';

class AddBusinessScreen extends StatefulWidget {
  const AddBusinessScreen({super.key});

  @override
  State<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();

  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instaController = TextEditingController();

  final TextEditingController youTubeController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController linkdinController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Observable for selected image
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void initState() {
    getFeildsById();
    userTypeController.text = 'My Self';
    // TODO: implement initState
    super.initState();
  }

  var isLoading = false;
  var feildsList = <MyData>[].obs;

  Future<void> getFeildsById() async {
    isLoading = true;
    try {
      final response = await ApiClient().getMyDetailsSignup();
      if (response['status']) {
        final businessPostModel = MyDetailsSignupModel.fromJson(response);
        feildsList.clear();
        feildsList.add(businessPostModel.data);
      } else {
        Get.snackbar('Error', response['message']);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading = false;
    }
  }

  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Business"),
      ),
      backgroundColor: primarybackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  // Show selected image or default avatar
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage.value != null
                        ? FileImage(selectedImage.value!)
                        : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider, // Replace with your placeholder image
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
                    activeColor: Colors.green, // Color when switch is ON
                    inactiveThumbColor: Colors.red, // Color when switch is OFF
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Obx(() {
                if (feildsList.isNotEmpty) {
                  final mySelfData = feildsList.first.business;

                  return _isSwitched
                      ? Column(
                    children: [
                      if (mySelfData.whatsapp) SizedBox(height: 5.h),
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

                      if (mySelfData.website)
                        NameInput(
                          labelText: "Website",
                          hintText: "Enter Website",
                          controller: websiteController,
                        ),

                      if (mySelfData.linkedin)
                        NameInput(
                          labelText: "Linkedin",
                          hintText: "Enter Linkedin",
                          controller: linkdinController,
                        ),
                      if (mySelfData.address)
                        NameInput(
                          labelText: "Address",
                          hintText: "Enter Address",
                          controller: addressController,
                        ),
                      // Add similar checks for other fields like insta, twitter, etc.
                    ],
                  )
                      : SizedBox();
                } else {
                  return CircularProgressIndicator();
                }
              }),
              // User type input field

              SizedBox(height: 4.h),

              // Submit button
              Container(
                  height: 85,
                  child: BottomButton(
                    color: primarybuttonColor,
                    text: "Add User",
                    onTap: () async {
                      // if (selectedImage.value != null) {
                      await uploadImg(
                        selectedImage.value,
                        nameController.text,
                        // userTypeController.text,
                        whatsappController.text,
                        instaController.text,
                        youTubeController.text,
                        twitterController.text,
                        websiteController.text,
                      );
                      // } else {
                      //   Get.snackbar('Error', 'Please select an image');
                      // }
                    },
                  )

                /*    CustomButton(
                  text: "Add",
                  color:  Color(0xff2C3E50FF),
                  onPressed: () async {
                    if (selectedImage.value != null) {
                      await uploadImg(
                        selectedImage.value!,
                        nameController.text,
                        userTypeController.text,
                      );
                    } else {
                      Get.snackbar('Error', 'Please select an image');
                    }
                  },
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? userprofileImage;
  final HomeSliderController controller = Get.put(HomeSliderController());

  // Function to handle image upload
  Future<void> uploadImg(
      File? image,
      String name,
      // String userType,
      String whatsaap,
      String insta,
      String youtube,
      String twitter,
      String about,
      ) async {
    print( controller.selectedIndex.value );
    // Assuming ApiClient.uploadImg is correctly defined elsewhere
    final response = await ApiClient.uploadImgSignup(
      imgPath: image?.path,
      name: name.isEmpty ? 'User Name' : name,
      userType:  "Business",
      about: aboutController.text,
      address: addressController.text,
      whatsapp: whatsappController.text,
      insta: instaController.text,
      twitter: twitterController.text,
      website: websiteController.text,
    );

    if (response != null) {
      if (response.status == true) {
        // Get.to(HomePage());
        final AddUserController addUserController = Get.put(AddUserController());

        addUserController.fetchAddUsers();
        Get.back();
      }
      // setState(() {
      //   userprofileImage = response.data!.profileImage;
      // });
    } else {
      Get.snackbar('Upload Failed', 'Could not upload the image.');
    }
  }
}
