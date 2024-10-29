import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CrouselButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final Widget? icon;

  const CrouselButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 0.4.w),
              ],
              Text(
                text,
                style: TextStyle(fontSize: 8.sp, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}