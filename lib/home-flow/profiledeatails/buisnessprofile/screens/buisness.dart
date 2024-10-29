import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/home-flow/profile/controller/profile_controller.dart';
import 'package:mihu/home-flow/profiledeatails/buisnessprofile/myDetailsModel.dart';

import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:sizer/sizer.dart';
import '../../../../network/models/upload_image_model.dart';
import '../../../../shared_widgets/name_input/namefield.dart';
import '../../../buisness_personal/controllers/selectioncontroller.dart';
import '../../../home/screen/homescreen.dart';

class MyBuissnessDetailsPage extends StatefulWidget {
  MyBuissnessDetailsPage({super.key});

  @override
  State<MyBuissnessDetailsPage> createState() => _MyBuissnessDetailsPageState();
}

class _MyBuissnessDetailsPageState extends State<MyBuissnessDetailsPage> {
  final SelectionController controller = Get.put(SelectionController());
  final TextEditingController buisnessnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instaController = TextEditingController();
  final TextEditingController linkdinController = TextEditingController();
  final TextEditingController youTubeController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController webSiteController = TextEditingController();
  final storage = GetStorage();
  final ProfileController profileController = Get.find();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  var isLoading = false;
  var businFeilds = <MyData>[].obs;
  bool _isSwitched = false;

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
      if (response['status'] == true) {
        final businessPostModel = MyDetailsSignupModel.fromJson(response);
        businFeilds.clear();
        businFeilds.add(businessPostModel.data);
      } else {
        // Handle error response
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
    }
  }

  // uploadImg(
  //     File? image,
  //     String name,
  //     String whatsaap,
  //     String insta,
  //     String youtube,
  //     String twitter,
  //     String about,
  //     String linkdin,
  //     ) async {
  //   UploadImgResponseModel2? response = await ApiClient.uploadImgBusinessAdd(
  //     imgPath: image?.path,
  //     name: name,
  //     userType: controller.userType ?? 'My Self',
  //     about: aboutController.text,
  //     address: addressController.text,
  //     whatsapp: whatsappController.text,
  //     insta: instaController.text,
  //     twitter: twitterController.text,
  //     website: webSiteController.text,
  //     linkdin: linkdinController.text,
  //   );
  //
  //   if (response != null && response.status == true) {
  //     profileController.fetchProfile();
  //     Get.offAll(() => HomePage());
  //   }
  // }

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
    // print( controller.selectedIndex.value );
    // Assuming ApiClient.uploadImg is correctly defined elsewhere
    final response = await ApiClient.uploadImgSignup(
      imgPath: image?.path,
      name: name.isEmpty ? 'User Name' : name,
      userType:  "Business",
      about: aboutController.text,
      address: addressController.text,
      whatsapp: whatsappController.text,
      insta: instaController.text,
      twitter: twitterController.text, website: webSiteController.text,
      // website: websiteController.text,
    );

    if (response != null) {
      if (response.status == true) {
        Get.to(HomePage());


      }
      // setState(() {
      //   userprofileImage = response.data!.profileImage;
      // });
    } else {
      Get.snackbar('Upload Failed', 'Could not upload the image.');
    }
  }

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
                child: Form(
                  key: _formKey, // Assign the form key
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            selectedImage.value = File(pickedFile.path);
                          }
                        },
                        child: Obx(() {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: selectedImage.value != null
                                ? FileImage(selectedImage.value!)
                                : NetworkImage(
                                'https://via.placeholder.com/150')
                            as ImageProvider,
                          );
                        }),
                      ),
                      SizedBox(height: 5.h),
                      // Business Name Input
                      TextFormField(
                        controller: buisnessnameController,
                        decoration: InputDecoration(
                          labelText: "Business Name",
                          hintText: "Enter Business Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a business name';
                          }
                          return null;
                        },
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
                              });
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Obx(() {
                        if (businFeilds.isNotEmpty) {
                          final businessData = businFeilds.first.business;
                          return _isSwitched
                              ? Column(
                            children: [
                              if (businessData.whatsapp)
                                SizedBox(height: 5.h),

                              NameInput(
                                labelText: "WhatsApp",
                                hintText: "Enter WhatsApp Number",
                                controller: whatsappController,
                                maxLength:10,
                                keyboard: TextInputType.phone, // Open numeric keyboard

                              ),
                              if (businessData.address)
                                NameInput(
                                  labelText: "Address",
                                  hintText: "Enter Address",
                                  controller: addressController,
                                ),

                              if (businessData.insta)
                                NameInput(
                                  labelText: "Instagram",
                                  hintText: "Enter Instagram",
                                  controller: instaController,
                                ),
                              if (businessData.twitter)
                                NameInput(
                                  labelText: "Twitter",
                                  hintText: "Enter Twitter",
                                  controller: twitterController,
                                ),

                              if (businessData.youtube)
                                NameInput(
                                  labelText: "Youtube",
                                  hintText: "Enter Youtube",
                                  controller: youTubeController,
                                ),

                              if (businessData.website)
                                NameInput(
                                  labelText: "Website",
                                  hintText: "Enter Website",
                                  controller: webSiteController,
                                ),
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
            ),
            BottomButton(
              color: primarybuttonColor,
              text: "Next",
              onTap: () async {
                // Validate the form
                if (_formKey.currentState!.validate()) {
                  // if (selectedImage.value == null) {
                  //   setState(() {
                  //     // Display error text if no image selected
                  //   });
                  // } else {
                    await uploadImg(
                      selectedImage.value,
                      buisnessnameController.text,
                      whatsappController.text,
                      instaController.text,
                      youTubeController.text,
                      twitterController.text,
                      aboutController.text,
                      // webSiteController.text
                    );
                  // }
                }
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
