import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/logo_model.dart';

class LogoController extends GetxController{

  Rx<Logo> logoUrl = Logo(status: true, message: "", data: "").obs;

  @override
  void onInit() {
    fetchLogoUrl();
    super.onInit();
  }

  void fetchLogoUrl()async{
    log('fetching logo url....');


    final  url = await ApiClient().fetchLogo();

    try{
      if(url != null){
        logoUrl.value = url;
        log('logoUrl: ${logoUrl.value}');
      }else{
        log('error fetching logo url');
      }
    }catch(e){
      Get.snackbar(
        'error',
        e.toString(),
        icon: Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,);
    }

  }

}