import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mihu/auth_workflow/screens/login_signup.dart';
import 'package:mihu/home-flow/add_user/add_user_controller.dart';
import 'package:mihu/network/models/upload_image_model.dart';
import 'package:mihu/shared_widgets/sharePrefRepo.dart';
import 'package:sizer/sizer.dart';
import '../../auth_workflow/controllers/signup_controller.dart';
import '../../home-flow/home/screen/homescreen.dart';
import '../models/logo_model.dart';

String ProfileImagePathUrl = "https://mihuapp.com/public/";

class ApiClient {
  final String baseUrl = "https://mihuapp.com/api";
    GetStorage? storage; // Declare storage as late final
    String? token; // Declare token as late and nullabl
  // Method to get settings

  ApiClient() {
    // Initialize storage and token in the constructor
    storage = GetStorage();
    token = storage!.read('accessToken');
    // token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL21paHVhcHAuY29tL2FwaS9sb2dpbiIsImlhdCI6MTcyNjA0MjcwOCwiZXhwIjoxNzg2MDQyNjQ4LCJuYmYiOjE3MjYwNDI3MDgsImp0aSI6IldqRFBhaXVxWmQ0WnFxNmQiLCJzdWIiOiIxMDMiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.3h5DWTbUELuR3RDFDS7dgYRm2SvB5SUc_WgW0E4guhE";
  }

  static Future<UploadImgResponseModel?> uploadImg({
    required String id,
    required String? imgPath,
    required String email,
    required String phone,
    required String name,
    required String userType,
    required String whatsapp,
    required String insta,
    required String twitter,
    required String website,
    required String about,
    required String address,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/user-profile/update/${id}');

    try {
      print(id);
      var request = http.MultipartRequest('POST', url);
      if (imgPath != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_image', imgPath));
      }
      request.headers.addAll(headers);

      // Add additional fields
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['name'] = name;
      request.fields['user_type'] = userType;

      request.fields['whatsaap'] = whatsapp;
      request.fields['instagram'] = insta;
      request.fields['wesite'] = website;
      request.fields['twitter'] = twitter;
      request.fields['about'] = about;
      request.fields['address'] = address;

      http.StreamedResponse response = await request.send();

      // Check for success
      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        print(stringData);
        var data = jsonDecode(stringData);
        UploadImgResponseModel uploadImgResponseModel =
        UploadImgResponseModel.fromJson(data);
        Fluttertoast.showToast(msg: data["message"] ?? 'Profile updated successfully!');
        return uploadImgResponseModel;
      } else {
        // Handle error response
        var stringData = await response.stream.bytesToString();
        print("Error Response: $stringData");
        var errorData = jsonDecode(stringData);
        Fluttertoast.showToast(msg: errorData["message"] ?? 'An error occurred.');
        return null;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  static Future<UploadImgResponseModel?> uploadImgSignup({
    required String? imgPath,
    required String name,
    required String userType,
    required String whatsapp,
    required String insta,
    required String twitter,
    required String website,
    required String about,
    required String address,
  }) async {
    String? email = await SharePref.getEmailId();
    String? phone = await SharePref.getUserMobile();

    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/user-profile');

    try {
      var request = http.MultipartRequest('POST', url);

      if (imgPath != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_image', imgPath));
      }

      request.headers.addAll(headers);
      print("showing User Type Sending-------");
print(userType);
      // Add additional fields
      request.fields['email'] = email ?? "email@gmail.com";
      request.fields['phone'] = phone ?? "15646464545";
      request.fields['user type'] = userType;
      request.fields['name'] = name;
      request.fields['whatsapp'] = whatsapp;
      request.fields['instagram'] = insta;
      request.fields['website'] = website;
      request.fields['twitter'] = twitter;
      request.fields['about'] = about;
      request.fields['address'] = address;

      http.StreamedResponse response = await request.send();
      var stringData = await response.stream.bytesToString(); // Fetch stream once
      print("Raw API Response: $stringData");

      var decodedResponse = jsonDecode(stringData); // Parse the JSON response

      if (response.statusCode == 200 && decodedResponse['status'] == true) {
        // Success case
        UploadImgResponseModel uploadImgResponseModel = UploadImgResponseModel.fromJson(decodedResponse);

        print("profile_id------");
        // Get.off(HomePage());

        // print(uploadImgResponseModel.data?.profileId);

        // Save the profile_id (if required)
        // ApiClient().storage?.write('profile_id', uploadImgResponseModel.data?.profileId);
userType="";
        return uploadImgResponseModel;
      } else {
        // If the status is false, show the error message from the response
        String errorMessage = decodedResponse['message'] ?? 'Unknown error occurred';
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.TOP,colorText: Colors.white,backgroundColor: Colors.black);

        return null;
      }
    } catch (e) {
      // In case of an exception, show it in a snackbar
      Get.snackbar('Exception', e.toString(), snackPosition: SnackPosition.BOTTOM);
      print(e);
      return null;
    }
  }


  static Future<UploadImgResponseModel2?> uploadImgBusinessAdd({
    required String? imgPath,
    required String name,
    required String userType,
    required String whatsapp,
    required String insta,
    required String twitter,
    required String website,
    required String about,
    required String address,
    required String linkdin,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/create-business');
    String? email = await SharePref.getEmailId();
    String? phone = await SharePref.getUserMobile();

    try {
      var request = http.MultipartRequest('POST', url);
      if(imgPath != null){
        request.files.add(await http.MultipartFile.fromPath('logo', imgPath));
      }
      request.headers.addAll(headers);

      // Add additional fields
      request.fields['email'] = email ?? ""; // Replace with actual email
      request.fields['number'] = phone ?? "1234567890"; // Replace with actual number
      request.fields['name'] = name;
      request.fields['whatsapp'] = whatsapp; // Ensure this is included
      request.fields['insta'] = insta;
      request.fields['twitter'] = twitter;
      request.fields['website'] = website;
      request.fields['about'] = about;
      request.fields['address'] = address;

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        Get.off(HomePage());
        print("Raw Response: $stringData");  // Print the entire response
        var data = jsonDecode(stringData);
        print("Parsed Response: $data");  // Print parsed response for clarity
        UploadImgResponseModel2 uploadImgResponseModel = UploadImgResponseModel2.fromJson(data);
        return uploadImgResponseModel;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null; // Indicate failure
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
      return null;
    }
  }

  static Future<GreetingUploadResponseModel?> uploadImgGreetingsAdd({
    required String imgPath,
    required String name,
    required String date,

    required String id,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/user-greeting/add');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('photo', imgPath));
      request.headers.addAll(headers);

      // Add additional fields
      request.fields['greeting_section_id'] = "3"; // Replace with actual email
      request.fields['date'] =date; // Replace with actual number
      request.fields['message'] = name;
// Now included

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        print("Raw Response: $stringData");  // Print the entire response
        var data = jsonDecode(stringData);
        print("Parsed Response: $data");  // Print parsed response for clarity
        GreetingUploadResponseModel uploadImgResponseModel = GreetingUploadResponseModel.fromJson(data);
        return uploadImgResponseModel;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null; // Indicate failure
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
      return null;
    }
  }

  static Future<GreetingUploadResponseModel?> uploadEditGreetings({
    required String imgPath,
    required int id,
    required String name,
    required String date,
    required int greetingID,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/user-greeting/update/${id}');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('photo', imgPath));
      request.headers.addAll(headers);

      // Add additional fields
      request.fields['greeting_section_id'] =
          greetingID.toString() ?? "3"; // Replace with actual email
      request.fields['date'] = date; // Replace with actual number
      request.fields['message'] = name;
// Now included

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        print("Raw Response: $stringData"); // Print the entire response
        var data = jsonDecode(stringData);
        print("Parsed Response: $data"); // Print parsed response for clarity
        GreetingUploadResponseModel uploadImgResponseModel =
            GreetingUploadResponseModel.fromJson(data);
        return uploadImgResponseModel;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null; // Indicate failure
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
      return null;
    }
  }

  static Future<GreetingUploadResponseModel?> uploadGallery({
    required List<String> imgPaths, // Accept multiple image paths

  }) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/gallery');

    try {
      var request = http.MultipartRequest('POST', url);

      // Loop through the list of image paths and add them as files to the request
      for (String imgPath in imgPaths) {
        request.files.add(await http.MultipartFile.fromPath('images[]', imgPath));
      }

      request.headers.addAll(headers);


      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        print("Raw Response: $stringData"); // Print the entire response
        var data = jsonDecode(stringData);
        print("Parsed Response: $data"); // Print parsed response for clarity
        GreetingUploadResponseModel uploadImgResponseModel =
        GreetingUploadResponseModel.fromJson(data);
        return uploadImgResponseModel;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null; // Indicate failure
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
      return null;
    }
  }


  // Method to get language data
  Future<Map<String, dynamic>> getLanguage() async {
    final response = await http.get(Uri.parse('$baseUrl/language'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });
    if (response.statusCode == 200) {
      log('data ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load language data');
    }
  }

  Future<Map<String, dynamic>> postLanguage() async {
    final response = await http.get(Uri.parse('$baseUrl/language'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });
    if (response.statusCode == 200) {
      log('data ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load language data');
    }
  }

  /// last api on signup
  Future<Map<String, dynamic>> getMyDetailsSignup() async {
    final response = await http
        .get(Uri.parse('https://mihuapp.com/api/field-status'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });
    if (response.statusCode == 200) {
      log('data ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load language data');
    }
  }


  // Method to get home data
  Future<List<Map<String, dynamic>>> getHomeData() async {
    final response =
        await http.get(Uri.parse('https://mihuapp.com/api/homedata'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load home data');
    }
  }

  // Method to get festival category

  Future<Map<String, dynamic>> getGreetingsCategoryClient() async {
    final response = await http.get(Uri.parse('$baseUrl/greeting-section'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });

    // Logging for debugging
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Handling different status codes
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: Greeting category does not exist');
    } else if (response.statusCode == 500) {
      throw Exception('Server Error: Please try again later');
    } else {
      throw Exception('Failed to load greetings category: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getGreetingPost(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/future-user-greeting/$id'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });

    // Logging for debugging
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: Greeting post does not exist');
    } else if (response.statusCode == 500) {
      throw Exception('Server Error: Please try again later');
    } else {
      throw Exception('Failed to load greeting post: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getGreetingsTodayCategory() async {
    final response = await http.get(Uri.parse('https://mihuapp.com/api/today-greeting-section'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });

    // Logging for debugging
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: Today greeting category does not exist');
    } else if (response.statusCode == 500) {
      throw Exception('Server Error: Please try again later');
    } else {
      throw Exception('Failed to load greetings category: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getGreetingsTodayCategoryPost(String id) async {
    final response = await http.get(Uri.parse('https://mihuapp.com/api/today-user-greeting/$id'), headers: {
      'Authorization': 'Bearer ${ApiClient().token}',
    });

    // Logging for debugging
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: Today greeting category post does not exist');
    } else if (response.statusCode == 500) {
      throw Exception('Server Error: Please try again later');
    } else {
      throw Exception('Failed to load greetings category post: ${response.body}');
    }
  }


  Future<List<Map<String, dynamic>>> getSliderImages() async {
    print("token: $token");
    final response =
        await http.get(Uri.parse('https://mihuapp.com/api/slider'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Log the data to check its structure
      log('data: ${data.toString()}');
      print(data);
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load slider images');
    }
  }

  Future<Logo?> fetchLogo() async {
    final response = await http.get(Uri.parse('$baseUrl/logo'));
    if (response.statusCode == 200) {
      log('resonpse from the api:${response.body} ');
      return Logo.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to load logo: ${response.statusCode}');
      return Logo.fromJson(jsonDecode(response.body));
    }
  }


  /// login api

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://mihuapp.com/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      log('login user : ${response.body}');
      log('login request : ${response.request}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('https://mihuapp.com/api/register'),
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );

    log('login request : ${response.body}');
    final decodedResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      log('login user : ${response.body}');
      log('Signup request : ${response.request}');
      print(response.body);

      return decodedResponse;
    } else {
      String errorMessage = decodedResponse['message'] ?? 'Failed to register user';

      // Display the error message using Fluttertoast
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Or display the error message using Get.snackbar
      // Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getFrameById() async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/frames/my%20self'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    // log('frames/$id request : ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get frame');
    }
  }

  Future<Map<String, dynamic>> getFestivalClient() async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/festival-category'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get frame');
    }
  }

  Future<Map<String, dynamic>> getBusinessCatClient() async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/business-category'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get frame');
    }
  }

  Future<Map<String, dynamic>> getBusinessPostClient() async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/business-post'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get frame');
    }
  }

  Future<Map<String, dynamic>> getFestivalPostById(String id) async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/festival-post/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    log('frames/$id request : ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get post');
    }
  }

  Future<Map<String, dynamic>> getBusinessPostById(String id) async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/business-post/$id'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    // log('frames/$id request : ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get post');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('https://mihuapp.com/api/profile'),
      headers: {
        'Authorization': 'Bearer ${ApiClient().token}',
      },
    );
    print("response ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get frame');
    }
  }

  Future<void> logout() async {
    try {
      // Using POST request for logout
      final response = await http.post(
        Uri.parse("https://mihuapp.com/api/logout"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiClient().token}', // replace with actual token
        },
      );

      if (response.statusCode == 200) {
        // Logout successful, handle accordingly
        Get.offAll(() => LoginSignup()); // Navigate to the login screen
        // Optionally show a success message
        Get.snackbar('Logout', 'Successfully logged out.',backgroundColor: Colors.black,colorText: Colors.white);
      } else {
        // Handle errors (e.g., unauthorized or server error)
        Get.snackbar('Logout Failed', 'Unable to logout. Please try again.',backgroundColor: Colors.black,colorText: Colors.white);
      }
    } catch (e) {
      // Handle network or other errors
      Get.snackbar('Error', 'An error occurred during logout: $e',backgroundColor: Colors.black,colorText: Colors.white);
    }
  }


}
