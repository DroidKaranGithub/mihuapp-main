import 'package:get/get.dart';



class SelectionController extends GetxController {
  String userType="";
  var selectedCard = ''.obs;

  void selectCard(String card) {
    selectedCard.value = card;
  }
}
