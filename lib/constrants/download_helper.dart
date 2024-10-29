import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mihu/home-flow/add-business_user/add_business_model.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/home-flow/add_user/add_user_model.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/frame_model.dart';
import 'package:mihu/network/models/profile_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

class DownloadHelper {
  static List<Widget> getFrameLayers(division,List<Layers> layers,{bool isBusiness = false}){
    List<Widget> frameLayers = [];
    final AddUserController addUserController = Get.put(AddUserController());
    final profiles = addUserController.addUserData.value?.data??[];
    final businessProfiles = addUserController.addBusinessData.value?.data??[]??[];

    final defaultProfiles = profiles.where((profile) => profile.datumDefault == 1).toList();
    final defaultBusiness = businessProfiles.where((profile) => profile.datumDefault == 1).toList();

    for (int i=0; i<layers.length;i++){
      if(layers[i].type == "image"){
        String img = "https://mihuapp.com/public${layers[i].src}";

        if (defaultProfiles.isNotEmpty) {
          if(layers[i].name == "logo"){
            if(defaultProfiles.first.profileImage.isNotEmpty){
              img = "${defaultProfiles.first.profileImage}";
            }
          }
        }
        if (defaultBusiness.isNotEmpty) {
          if(layers[i].name == "logo"){
            if(defaultBusiness.first.logo.isNotEmpty){
              img = "${defaultBusiness.first.logo}";
            }
          }
        }
        frameLayers.add(Positioned(
          top: layers[i].y!.toDouble() / division,
          left: layers[i].x!.toDouble() / division,
          child: CachedNetworkImage(imageUrl: img,fit: BoxFit.cover,height: layers[i].height!.toDouble() / division,width: layers[i].width!.toDouble() / division,),
        ));
      }
      if(layers[i].type == "text"){
        String text = "${layers[i].text}";
        if (defaultProfiles.isNotEmpty) {
          DatumAddUser profile = defaultProfiles.first;
          if(layers[i].name == "email"){
            text = profile.email ?? "";
          }
          if(layers[i].name == "name"){
            text = profile.name ?? "";
          }
          if(layers[i].name == "about"){
            text = profile.about ?? "";
          }
        }

        if (defaultBusiness.isNotEmpty) {
          BusinessDatum profile = defaultBusiness.first;
          if(layers[i].name == "email"){
            text = profile.email ?? "";
          }
          if(layers[i].name == "name"){
            text = profile.name ?? "";
          }
          if(layers[i].name == "address"){
            text = profile.address ?? "";
          }
          if(layers[i].name == "number"){
            text = profile.number ?? "";
          }
          if(layers[i].name == "facebook"){
            text = profile.facebook ?? "";
          }
          if(layers[i].name == "instagram"){
            text = profile.insta ?? "";
          }
          if(layers[i].name == "youtube"){
            text = profile.youtube ?? "";
          }
        }

        frameLayers.add(Positioned(
          top: layers[i].y!.toDouble() / division,
          left: layers[i].x!.toDouble() / division,
          child: Text(text,style: TextStyle(fontSize: layers[i].size!.toDouble() / (division == 1 ? 1 : division+1),color: Color(int.parse("${layers[i].color!.replaceAll("0x", "0xff")}")),fontWeight: layers[i].weight == "bold" ? FontWeight.bold : FontWeight.normal,),
          ),
        ),
        );
      }
    }
    return frameLayers;
  }

  static downloadPhoto(layers,image)async{
    var frameLayers2 = getFrameLayers(1,layers);
    List<Layers> home = layers.where((element) => element.x! <= 0 && element.y! <= 0,).toList();

    var capturedImage = await ScreenshotController().captureFromLongWidget(Container(
      height: (home.isEmpty ? 1200 : home.first.height!.toDouble()),
      width: (home.isEmpty ? 1200 : home.first.width!.toDouble()),
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl:image,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          ...frameLayers2,
        ],
      ),
    ),delay: Duration(seconds: 2));
    final result = await ImageGallerySaver.saveImage(capturedImage,
      quality: 100,
      name: "${DateTime.now()}",
    );
    Get.snackbar('Success', 'Image saved successfully',colorText: Colors.white,backgroundColor: Colors.black);
  }

  static shareImage(layers,image,{bool isBusiness = false})async{
    var frameLayers2 = getFrameLayers(1,layers,isBusiness: isBusiness);
    List<Layers> home = layers.where((element) => element.x! <= 0 && element.y! <= 0,).toList();

    var capturedImage = await ScreenshotController().captureFromLongWidget(Container(
      height: (home.isEmpty ? 1200 : home.first.height!.toDouble()),
      width: (home.isEmpty ? 1200 : home.first.width!.toDouble()),
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl:image,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          ...frameLayers2,
        ],
      ),
    ),delay: Duration(seconds: 2));
    var tempDir = await getTemporaryDirectory();
    String savePath = '${tempDir.path}/${DateTime.now()}.png';
    File file = File(savePath);
    await file.writeAsBytes(capturedImage);

    Share.shareXFiles([XFile(file.path)], text: 'Check out this image!');
  }
}