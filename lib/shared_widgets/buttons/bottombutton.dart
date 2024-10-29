import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BottomButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onTap;

  const BottomButton({
    required this.color,
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity,
              50), // Set the width to infinity and height to 50
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Round the button edges
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
