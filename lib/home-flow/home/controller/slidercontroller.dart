import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mihu/check_internet.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/frame_model.dart';

import 'package:mihu/home-flow/home/controller/mediaitem.dart';
import 'package:mihu/home-flow/home/festival_cat_model.dart';
import 'package:mihu/home-flow/home/get_category_data_model.dart';

import '../../../network/models/upload_image_model.dart';
import '../model/business_cat_model.dart';
import '../model/businesspost_model.dart';

class SliderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getFrameById("4");
    getFestivalPostById("23");
    getFestivalCategory();
  }

  var isFrameLoading = false.obs;
  List<FrameModel> frames = [];

  Future<void> getFrameById(String id) async {
    isFrameLoading(true);
    CheckInternet().hasNetwork().then((hasInternet) async {
      if (hasInternet) {
        try {
          final response = await ApiClient().getFrameById();
          if (response['status']) {
            List data = response['data'];
            frames = data
                .map((e) => FrameModel.fromJson(jsonDecode(e['json'])))
                .toList();
          } else {
            // Get.snackbar('Error', response['message']);
          }
        } catch (e) {
          print("Eee ${e}");
          // Get.snackbar('Error', e.toString());
        } finally {
          isFrameLoading(false);
        }
      }
    });
  }

  // List<Datum> festivalCatList = [];
  var festivalCatList = <Datum>[].obs;

  var isCatLoading = false.obs;

  Future<void> getFestivalCategory() async {
    isCatLoading(true); // Uncomment if using a loading indicator
    try {
      final response = await ApiClient().getFestivalClient();
      if (response['status']) {
        // Using FastivalCatModel to map the response
        final festivalData = FastivalCatModel.fromJson(response);

        // Clear the current list before adding new data
        festivalCatList.clear();

        // Add new items to the observable list
        festivalCatList.addAll(festivalData.data); // Use addAll here

        print("Festival Data:");
        print(festivalCatList);
      } else {
        // Get.snackbar('Error', response['message']);
      }
    } catch (e) {
      print("Error: ${e}");
      // Get.snackbar('Error', e.toString());
    } finally {
      isCatLoading(false); // Set loading state to false
    }
  }

  List<DataCategory> categoryList = [];
  bool categorySelected = false;


  var isPostLoading = false.obs;
  var errorMessage = "".obs;
  var posts = <dynamic>[].obs; // Change this to RxList

  Future<void> getFestivalPostById(String id) async {
    isPostLoading.value = (true);
    try {
      final response = await ApiClient().getFestivalPostById(id);
      if (response['status']) {
        posts.assignAll(response['data']);
      } else {
        // errorMessage.value = response['message'];
        // Get.snackbar('Error', response['message']);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      // Get.snackbar('Error', e.toString());
    } finally {
      isPostLoading(false);
    }
  }

  var businPosts = <DataBusiness>[].obs;

  Future<void> getBusinessPostById(String id) async {
    isPostLoading(true);
    try {
      final response = await ApiClient()
          .getBusinessPostById(id.toString()); // Adjust to your API method
      if (response['status']) {
        final businessPostModel = BusinessPostModel.fromJson(response);
        businPosts.clear();

        // Convert DataBusinessPost to BusinessPostModel and add to businPosts
        businPosts.addAll(businessPostModel.data.map((dataPost) => dataPost));
      } else {
        // Get.snackbar('Error', response['message']);
        // errorMessage.value = response['message'];
      }
    } catch (e) {
      print("Error: $e");
      // Get.snackbar('Error', e.toString());
      // errorMessage.value = e.toString();
    } finally {
      isPostLoading(false);
    }
  }

  var businessCatList = <DataCat>[].obs; // Use Data as per your model
  // var isCatLoading = false.obs; // Observable for loading state

  Future<void> getBusinessCategory() async {
    isCatLoading(true); // Set loading state to true
    try {
      final response = await ApiClient().getBusinessCatClient();
      if (response['status']) {
        // Map the response to BusinessCatModel
        final businessCatModel = BusinessCatModel.fromJson(response);

        // Clear the current list before adding new data
        businessCatList.clear();

        // Add new items to the observable list
        businessCatList.addAll(businessCatModel.data); // Use addAll here

        print("Business Data:");
        print(businessCatList); // Print the observable list
      } else {
        // Get.snackbar('Error', response['message']);
      }
    } catch (e, s) {
      print("Error: ${e}");
      print("Error: ${s}");
      // Get.snackbar('Error', e.toString());
    } finally {
      isCatLoading(false); // Set loading state to false
    }
  }
}
