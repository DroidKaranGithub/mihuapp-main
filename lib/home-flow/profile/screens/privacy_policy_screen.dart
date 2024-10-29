import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:get/get.dart';
import 'package:mihu/home-flow/home/controller/home_data_controller.dart';
import 'package:mihu/home-flow/home/controller/home_data_items.dart';

class PrivacyPolicyScreen extends StatelessWidget {

   PrivacyPolicyScreen({super.key});

   final HomeDataController homeDataController = Get.find<HomeDataController>();


   String getHtmlContent() {
     final item = homeDataController.homeDataItems.firstWhere((element)=>element.field == "privacypolicy",
       orElse: ()=> HomeDataItems(id: 0, value: '', field: '')
     ).value;
     log('${item}');
     return item ?? '';
   }



  @override
  Widget build(BuildContext context) {


    return Obx(() {
      // Ensure the HomeDataController is used to reactively get data
      final item = homeDataController.homeDataItems.firstWhere(
            (element) => element.field == "privacypolicy",
        orElse: () => HomeDataItems(id: 0, field: '', value: ''),
      );
      final String htmlContent = getHtmlContent();


      final document = html_parser.parse(htmlContent);
      final paragraphElement = document.querySelector('p');
      final String paragraphText = paragraphElement != null ? paragraphElement.text : '';

      return Scaffold(
        appBar: AppBar(
          title: Text('Privacy Policy',style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20
          ),),
          backgroundColor: Colors.grey.shade800,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,

            child: HtmlWidget(paragraphText),
          ),
        ),
      );
    });

  }
}
