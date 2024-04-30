import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class MyTextField extends StatefulWidget {
  final Widget? suffixIcon;
  final double? containerWidth;
  final String? labelText;
  final bool obscureText;
  final bool
      obscureTextInitially; // New parameter to control initial text visibility
  final TextEditingController? controller;

  const MyTextField({
    Key? key,
    this.labelText,
    this.controller,
    this.containerWidth,
    this.suffixIcon,
    this.obscureText = false,
    this.obscureTextInitially = false, // Set to false by default
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordObscure =
      false; // Initialize with false for the password field

  void _toggleTextVisibility() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    _isPasswordObscure = widget
        .obscureTextInitially; // Set initial text visibility based on parameter
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: widget.containerWidth,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        obscureText: widget.obscureText &&
            _isPasswordObscure, // Consider both parameters
        style: GoogleFonts.mulish(
          color: Color.fromARGB(194, 255, 255, 255),
          letterSpacing: 0.2,
          fontSize: 15.sp,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: GoogleFonts.mulish(
            color: Color.fromARGB(194, 255, 255, 255),
            letterSpacing: 0.2,
            fontSize: 15.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.sp),
            borderSide: BorderSide(color: Color.fromARGB(108, 255, 255, 255)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.sp),
            borderSide: BorderSide(color: Color.fromARGB(108, 255, 255, 255)),
          ),
          filled: true,
          fillColor: Color.fromARGB(59, 255, 255, 255),
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: _toggleTextVisibility,
                  child: widget.suffixIcon,
                )
              : null,
        ),
      ),
    );
  }
}
