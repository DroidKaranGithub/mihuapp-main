// import 'package:get/get.dart';
//
// class LanguageController extends GetxController {
//
//   var selectedLanguage = ''.obs;
//
//   void selectCard(String card) {
//
//   }
//
//   void selectLanguage(String language) {
//     selectedLanguage.value = language;
//   }
// }



import 'dart:developer';
import 'package:get/get.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';

class LanguageController extends GetxController {
  var languages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedLanguage = ''.obs;
  final ApiClient apiClient;

  LanguageController({required this.apiClient});

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();
  }

  void fetchLanguages() async {
    try {
      isLoading(true);
      var response = await apiClient.getLanguage();

      if (response['status'] == true && response['data'] != null) {
        languages.value = List<Map<String, dynamic>>.from(response['data']);
        // log('Fetched languages: ${languages.length}');
      } else {
        // errorMessage.value = 'No data found or invalid response format';
      }
    } catch (e) {
      // errorMessage.value = 'Error fetching languages: ${e.toString()}';
      // Get.snackbar('Error', e.toString());
      // log('${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }
}
