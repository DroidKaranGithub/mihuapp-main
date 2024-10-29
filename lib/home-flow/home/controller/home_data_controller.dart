import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/post_model.dart';
import 'package:mihu/home-flow/home/controller/home_data_items.dart';

class HomeDataController extends GetxController{
  var homeDataItems = <HomeDataItems>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
   fetchHomeData();
   getHomecategoryData();
    super.onInit();
  }

  void fetchHomeData()async{
    try{
      log('----');
      isLoading(true);
      List<Map<String,dynamic>> data = await ApiClient().getHomeData();
      // log('data : ${data}');
      homeDataItems.value = data.map((data){
        final int id = data['id'];
        final String? field = data['field'];
        final String? value = data['value'];
        return HomeDataItems(id: id, field: field ,value: value);
      }).toList();
      if(homeDataItems.isEmpty){
        errorMessage.value = 'No media available';
        Get.snackbar('error', errorMessage.toString() );
      }
    }catch(e){
      Get.snackbar('error', e.toString(),colorText: Colors.white,backgroundColor: Colors.black);
      log('${e.toString()}');
    }finally{
      isLoading(false);
    }
  }



  void getHomecategoryData()async{
    try{
      log('--priyehhhhhh--');
      isLoading(true);
      List<Map<String,dynamic>> data = await ApiClient().getHomeData();
       log('data : ${data}');
      homeDataItems.value = data.map((data){
        final int id = data['id'];
        final String? field = data['name'];
        final String? value = data['image'];
        return HomeDataItems(id: id, field: field ,value: value);
      }).toList();
      if(homeDataItems.isEmpty){
        errorMessage.value = 'No media available';
        Get.snackbar('error', errorMessage.toString() ,colorText: Colors.white,backgroundColor: Colors.black);
      }
    }catch(e){
      Get.snackbar('error', e.toString());
      log('${e.toString()}');
    }finally{
      isLoading(false);
    }
  }
}