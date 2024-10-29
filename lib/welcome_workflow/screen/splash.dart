import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/welcome_workflow/controllers/splashcontroller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final SplashController _splashController = Get.put(SplashController());
  //
  // final logoController = Get.put(LogoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarybackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                  'assets/images/mihulogo.png'), // Replace with your image asset
            ),

            // child: Obx(()=> logoController.logoUrl.value.data.isEmpty
            //     ? const Center(
            //   child: CircularProgressIndicator(),
            // )
            //     :Center(
            //   child: SizedBox(
            //     width: 200,
            //       child: Image.network(logoController.logoUrl.value.data)),
            // )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Lottie.asset(
                  'assets/loading.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
