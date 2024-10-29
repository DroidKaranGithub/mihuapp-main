import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NameInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboard; // Changed to non-nullable with a default
  final int maxLength; // Changed to non-nullable with a default
  final TextEditingController controller;

  // Constructor with optional parameters
  NameInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboard = TextInputType.text, // Default to text input
    this.maxLength = 75, // Default max length
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 10.h,
          width: 80.h,
          child: TextField(
            controller: controller,
            keyboardType: keyboard, // Use provided or default keyboard type
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
            ),
            maxLength: maxLength, // Use provided or default max length
          ),
        ),
      ],
    );
  }
}

// If needed, you can also keep CustomTextInput
class CustomTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final int maxLength;

  const CustomTextInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.maxLength = 75, // Default max length
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 10.h,
          width: 80.w,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hintText,
            ),
            maxLength: maxLength,
          ),
        ),
      ],
    );
  }
}
