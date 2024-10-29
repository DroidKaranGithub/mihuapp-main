import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:mihu/home-flow/home/controller/home_data_controller.dart';
import 'package:mihu/home-flow/home/controller/home_data_items.dart';
import 'package:html/parser.dart' as html_parser;

class TermsServicesScreen extends StatelessWidget {
  TermsServicesScreen({super.key});


  final HomeDataController homeDataController = Get.find<HomeDataController>();


 String  fetchHtmlDocument(){

     final item = homeDataController.homeDataItems.firstWhere((element)=> element.field == 'terms_and_condition',
       orElse: ()=> HomeDataItems(id: 0, value: '', field: '')
     ).value;
     return item ?? '';





 }

  @override
  Widget build(BuildContext context) {
    return  Obx(() {
      final String htmlContent = fetchHtmlDocument();







      return Scaffold(
        appBar: AppBar(
          title: Text('Terms and Services',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20
          ),),
          backgroundColor: Colors.grey.shade800,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20 , vertical:  20),
            alignment: Alignment.center,

            child: HtmlWidget(
              htmlContent,
              textStyle: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ),
      );
    });
  }
}
