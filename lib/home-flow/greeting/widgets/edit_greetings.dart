import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/home/controller/mediaitem.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:mihu/home-flow/home/elements/combined_carousel_widget.dart';
import 'package:mihu/shared_widgets/buttons/customvtn.dart';
import 'package:mihu/shared_widgets/carsoles/carsoules.dart';
import 'package:mihu/shared_widgets/name_input/namefield.dart';
import 'package:sizer/sizer.dart';

class EditGreetings extends StatelessWidget {
  final int id;

  final TextEditingController messageController = TextEditingController();

  // final List<MediaItem> mediaItems = [
  //   MediaItem(path: 'assets/images/crouselposttwo.jpg', isImage: true),
  //   MediaItem(path: 'assets/videos/sample1.mp4', isImage: false), // Sample video
  // ];
  EditGreetings({required this.id});

  final SliderController sliderController = Get.put(SliderController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundColorWhite,
        automaticallyImplyLeading: false, // Remove back arrow
        title: Text(
          'Edit Greeting',
          style: TextStyle(fontSize: 18.sp), // Reduce text size
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 40.sp,
                      backgroundImage: AssetImage('assets/icons/profile.png'), // Add your image path here
                      backgroundColor: Color(0xFFF9F9F9),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              TextButton(
                onPressed: () {
                  // Handle photo upload
                },
                child: Text(
                  'Upload Photo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomTextInput(
                labelText: 'Message',
                hintText: 'Enter Message',
                controller: messageController,
                maxLength:50,

              ),
              SizedBox(height: 1.h),
              // CombinedCarouselWidget( showEditButttom: false,),
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(text: 'Back', color: SecondarybuttonColor, onPressed: () {
                      Get.back();
                    }),
                    SizedBox(width: 4.w),
                    CustomButton(text: 'Update', color: primarybuttonColor, onPressed: () {
                      // Handle update action
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
