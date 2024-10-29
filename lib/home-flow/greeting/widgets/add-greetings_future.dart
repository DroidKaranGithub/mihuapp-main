import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/greeting/contollers/future_greetings_controller.dart';
import 'package:mihu/home-flow/greeting/greetings_category_model.dart';
import 'package:mihu/home-flow/greeting/today%20GreetingsModel.dart';
import 'package:mihu/shared_widgets/buttons/customvtn.dart';
import 'package:mihu/shared_widgets/uploadphoto/uploadphoto.dart';
import 'package:sizer/sizer.dart';

import '../../../network/apiclient.dart/apicilent.dart';
import '../../../network/models/upload_image_model.dart';
import '../../home/screen/homescreen.dart';

class NewGreetingPageFuture extends StatefulWidget {
  final RxList<GreetingsCatList> greetingTodayList;
  NewGreetingPageFuture(this.greetingTodayList, {super.key});

  @override
  _NewGreetingPageFutureState createState() => _NewGreetingPageFutureState();
}

class _NewGreetingPageFutureState extends State<NewGreetingPageFuture> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
      _isLoading = true;
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;

        });
      }
    } catch (e) {
      // Handle errors if any
    } finally {
        _isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      appBar: AppBar(
        title: const Text("   Set New Greeting"),
        backgroundColor: backgroundColorWhite,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child:Column(
              children: [
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.w, // Ensuring circular shape
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: ClipOval(
                          child: imageFile == null
                              ? Image.asset(
                            'assets/icons/profilemain.png',
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (_isLoading)
                        Center(
                          child: Lottie.asset('assets/loading.json',
                              repeat: true, animate: true, width: 40),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Upload Photo',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            SizedBox(height: 2.h),
            Text(
              "Message",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Enter Message",
                fillColor: Colors.white,
                filled: true,
                counterText: "${messageController.text.length}/50",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              maxLength: 50,
            ),
            SizedBox(height: 2.h),
            Text(
              "Category",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: backgroundColorWhite,
              ),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: "Choose Category",
                  fillColor: backgroundColorWhite,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: widget.greetingTodayList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name, // Assuming `name` is a property of GreetingsCatList
                        child: Text(category.name), // Display the name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                        // selectedCategory = value;
                    },
                  ),
                ),
              ),
            ),            SizedBox(height: 2.h),
            Text(
              "Date",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Select Date",
                fillColor: backgroundColorWhite,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.calendar_today),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          surface: backgroundColorWhite,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: backgroundColorWhite,
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                    dateController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "Back",
                  color: SecondarybuttonColor,
                  onPressed: () {
                    Navigator.pop(context);
                    // Get.back();
                  },
                ),
                SizedBox(width: 6.w),
                CustomButton(
                  text: "Set",
                  color: primarybuttonColor,
                  onPressed: () async {
                    if (imageFile?.path != null) {
                      await uploadNewGreetingsImg(

                        imageFile!,
                        messageController.text,
                        "1",
                        dateController.text,


                      );
                    }else{
                      Fluttertoast.showToast(msg: "Please select profile pic first",backgroundColor: Colors.black,textColor: Colors.white);
                    }

                    // Get.back();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
  final GreetingController greetingController =
  Get.put(GreetingController(), permanent: true);
  uploadNewGreetingsImg(

      XFile image,
      String name,
      String greeting_section_id,

      String date,
      ) async {
    String formattedDate = formatDate(date);
    GreetingUploadResponseModel? response = await ApiClient.uploadImgGreetingsAdd(
      id: greeting_section_id,
      imgPath: image.path.toString(),

      name: name.isNotEmpty ? name : 'User Name',
      date: formattedDate,


    );

    if (response != null) {
      if (response.status == true) {
        Fluttertoast.showToast(msg: response.message ?? 'Greeting created successfully!');

        // Extracting the data from the response


        // Optionally, you can save or display this information as needed


        // Optionally, fetch updated profile data and update the UI


        // Navigate to homepage or refresh UI
        // Get.offAll(() => HomePage());
        Get.back();
        greetingController.GreetingpostApi("");
      } else {
        // Handle cases where status is false
        Fluttertoast.showToast(msg: response.message ?? 'Failed to create greeting.');
      }
    } else {
      Fluttertoast.showToast(msg: 'Error creating greeting. Please try again.');
    }
  }
  String formatDate(String date) {
    // Assuming date is in the format "DD/MM/YYYY"
    List<String> parts = date.split('/');
    if (parts.length == 3) {
      // Rearranging to "YYYY-MM-DD"
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date; // Return original if parsing fails
  }

}
