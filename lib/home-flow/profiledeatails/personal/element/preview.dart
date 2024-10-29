import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PreviewCard extends StatelessWidget {
  final String name;
  final bool isWhatsappEnabled;

  const PreviewCard({
    super.key,
    required this.name,
    this.isWhatsappEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 71, 69, 69)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 14.sp),
          ),
          if (isWhatsappEnabled) ...[
            Spacer(),
          ],
        ],
      ),
    );
  }
}
