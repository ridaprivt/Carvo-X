// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/Views/Auth/signin_screen.dart';
import 'package:modula/Model/utils/utils.dart';
import 'package:modula/Model/widgets/my_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.05, 0.25, 0.5],
                colors: [
                  Colors.black,
                  Color.fromARGB(255, 65, 3, 94),
                  Colors.black,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(11.w, 0, 11.w, 0.h),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 80.w,
                    ),
                    SizedBox(height: 6.h),
                    GradientText(
                      'Sign Up',
                      style: GoogleFonts.mulish(
                        fontSize: 19.5.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                      colors: [
                        Color(0xff924FFF),
                        Color(0xffD61672),
                        Color(0xffF442B5),
                        Color(0xff899CFF),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    MyTextField(
                      labelText: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(height: 1.3.h),
                    MyTextField(
                      labelText: 'Password',
                      obscureText: true,
                      obscureTextInitially: true,
                      suffixIcon: Image.asset('assets/eye.png'),
                      controller: passwordController,
                    ),
                    SizedBox(height: 1.3.h),
                    MyTextField(
                      labelText: 'Confirm Password',
                      obscureText: true,
                      obscureTextInitially: true,
                      suffixIcon: Image.asset('assets/eye.png'),
                      controller: confirmPasswordController,
                    ),
                    SizedBox(height: 1.3.h),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 0.5.w),
                        MaterialButton(
                            padding: EdgeInsets.all(0),
                            minWidth: 5.w,
                            onPressed: () {
                              Get.offAll(SignIn());
                            },
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                fontSize: 15.5.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          signUpWithFirebase();
                        },
                        child: Container(
                          height: 5.5.h,
                          width: 62.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xff41035E),
                              borderRadius: BorderRadius.circular(33.sp)),
                          child: isSigningUp
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mulish(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signUpWithFirebase() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill out all fields',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return; // Exit the function if any field is empty
    }

    // Validate the email format
    final emailPattern = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    if (!emailPattern.hasMatch(emailController.text)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return; // Exit the function if email format is invalid
    }

    // Validate the password length
    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 8 characters long',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return;
    }
    if (confirmPasswordController.text.length < 8) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 8 characters long',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return;
    }
    if (confirmPasswordController.text != passwordController.text) {
      Get.snackbar(
        'Passwords not matched',
        'please enter same passwords',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return; // Exit the function if any field is empty
    }

    setState(() {
      isSigningUp = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          'Success',
          'Please check your email to verify your account',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      emailController.clear();
      passwordController.clear();
      Get.off(SignIn());
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Failed',
        'Failed to verify account: $e',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
