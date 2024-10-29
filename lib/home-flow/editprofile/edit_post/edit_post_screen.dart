import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/home-flow/profiledeatails/buisnessprofile/myDetailsModel.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/frame_model.dart';
import 'package:mihu/network/models/upload_image_model.dart';
import 'package:mihu/home-flow/home/screen/homescreen.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:mihu/shared_widgets/buttons/customvtn.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:mihu/shared_widgets/sharePrefRepo.dart';
import 'package:sizer/sizer.dart';

class EditprofilePost extends StatefulWidget {
  final dynamic post; // The post data from the carousel
  final List<Layers> layers; // The layers of the selected frame
  final int type; // The layers of the selected frame

  const EditprofilePost(
      {Key? key, required this.post, required this.layers, required this.type})
      : super(key: key);

  @override
  State<EditprofilePost> createState() => _EditprofileState();
}

class _EditprofileState extends State<EditprofilePost> {
  final AddUserController addUserController = Get.put(AddUserController());

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
    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    // Check if profile data is available, then set default values
    final profile = profileController.profileData.value;
    if (profile != null && addUserController.defaultProfilesList.isNotEmpty) {

      setState(() {
        nameController.text = widget.type == 0
            ? addUserController.defaultProfilesList.first.name
            :   addUserController.addUserData.value?.data.first.name??"";
      });
    } else {
      // Handle the case when the list is empty
      nameController.text = ''; // Or set to a default value
    }
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
        // Now that data is loaded, initialize text controllers
        _initializeTextControllers();
      } else {
        Get.snackbar('Error', response['message'],
            colorText: Colors.white, backgroundColor: Colors.black);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', e.toString(),
          colorText: Colors.white, backgroundColor: Colors.black);
    } finally {
      isLoading = false;
    }
  }

  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    print(widget.post);
    print("mypost-----");
    // print(addUserController.defaultProfilesList.first.profileId);
    // print(addUserController.addUserData.value?.data.first.name);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        backgroundColor: primarybackgroundColor,
        body: Obx(() {
          // Use Obx to reactively listen to changes in the observable list
          if (widget.type == 0) {
            if (addUserController.defaultProfilesList.isEmpty) {
              return Center(child: Text("No Default Profile"));
            }
            // Set the nameController text based on the first profile if the list is not empty
            nameController.text =
                addUserController.defaultProfilesList.first.name;
          } else {
            // Handle the case for type 1 or other types accordingly
            // You can similarly check if addUserController.addUserData is not null and update accordingly
            nameController.text =
                addUserController.addUserData.value?.data.first.name ?? '';
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
                            : NetworkImage(widget.type == 0
                                    ? addUserController
                                        .defaultProfilesList.first.profileImage
                                    : addUserController.addUserData.value!.data
                                        .first.profileImage) // Placeholder
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
                        trackOutlineColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.orange;
                          }
                          return null; // Use the default color.
                        }),
                        activeColor: Colors.green,
                        // Color when switch is ON
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
                          // if (selectedImage.value != null) {
                          await uploadImg(
                            (widget.type == 0
                                    ? addUserController
                                        .addUserData.value?.data.first.profileId
                                    : addUserController.addUserData.value!.data
                                        .first.profileId)
                                .toString(),
                            selectedImage.value,
                            nameController.text,
                            whatsappController.text,
                            instaController.text,
                            youTubeController.text,
                            twitterController.text,
                            aboutController.text,
                          );
                          // }else{
                          //   Fluttertoast.showToast(msg: "Please select profile pic first",backgroundColor: Colors.black,textColor: Colors.white);
                          // }
                        },
                      )),
                ],
              ),
            ),
          );
        }));
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
      email: email ?? "",
      phone: phone ?? "",
      name: name.isNotEmpty ? name : 'User Name',
      userType: widget.type == 0 ? 'My Self' : "Business",
      about: aboutController.text,
      address: addressController.text,
      whatsapp: whatsappController.text,
      insta: instaController.text,
      twitter: twitterController.text,
      website: webSiteController.text,
    );

    if (response != null) {
      if (response.status == true) {
        Fluttertoast.showToast(
            msg: response.message ?? 'Profile updated successfully!');
        profileController.fetchProfile();
        Get.offAll(() => HomePage());
      } else {
        // Show specific error message from the response
        // Fluttertoast.showToast(msg: response.message ?? 'Failed to update profile.');
      }
    } else {
      // Handle case where response is null
      Fluttertoast.showToast(msg: 'Error updating profile. Please try again.');
    }
  }
}
