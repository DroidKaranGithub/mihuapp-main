import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FacebookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FacebookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.facebook),
      label: Text('Continue with Facebook'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        minimumSize: Size(double.infinity, 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
