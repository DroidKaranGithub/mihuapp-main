import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final String hintText;
  final String headText;
  final bool enableVisibilityToggle;
  final bool enableVisibilityToggle1;
  final FormFieldValidator<String>? validator;

  const PasswordField({
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    required this.hintText,
    required this.headText,
    this.enableVisibilityToggle = true,
    this.enableVisibilityToggle1 = true,
    this.validator,
    super.key,
  });

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;
  bool _isObscured1 = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
      _isObscured1 = !_isObscured1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.headText,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Replace with primaryboxColor
            borderRadius: BorderRadius.circular(8),
              border: Border.all(color:  Colors.grey)
          ),
          child: TextFormField(

            validator: widget.validator ,
            controller: widget.controller,
            focusNode: widget.focusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              widget.focusNode.unfocus();
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
            obscureText: widget.enableVisibilityToggle ? _isObscured : false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.w, vertical: 2.h),
              suffixIcon: widget.enableVisibilityToggle
                  ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _toggleVisibility,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
