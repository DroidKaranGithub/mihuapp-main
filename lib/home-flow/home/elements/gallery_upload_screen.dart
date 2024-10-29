import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/home-flow/home/elements/gallery_comobined_carousel.dart';
import 'package:mihu/shared_widgets/buttons/bottombutton.dart';
import 'package:mihu/shared_widgets/uploadphoto/uploadphoto.dart';
import 'package:sizer/sizer.dart';


class GalleryUploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundColorWhite,
        title: Text("Gallery Upload"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // UploadPhoto(),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: GalleryComobinedCarousel(),
             ),
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BottomButton(
                  color: SecondarybuttonColor,
                  text: "Back",
                  onTap: () {
                    // Handle back functionality
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
