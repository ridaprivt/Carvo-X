// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/Views/Auth/UserInfo.dart';
import 'package:modula/Model/widgets/my_textfield.dart';
import 'package:modula/Views/Screens/dashboard_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'signup_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                stops: [0.1, 0.23, 0.6],
                colors: [
                  Colors.black,
                  Color.fromARGB(255, 65, 3, 94),
                  Colors.black,
                ],
              )),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 80.w,
                      ),
                      SizedBox(height: 6.h),
                      GradientText(
                        'Let’s sign you in',
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
                      SizedBox(height: 3.h),
                      MyTextField(
                        labelText: 'Email',
                        controller: emailController,
                      ),
                      SizedBox(height: 1.5.h),
                      MyTextField(
                        labelText: 'Password',
                        controller: passwordController,
                        suffixIcon: Image.asset('assets/eye.png'),
                        obscureText: true,
                        obscureTextInitially: true,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mulish(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.5.w),
                          MaterialButton(
                              padding: EdgeInsets.all(0),
                              minWidth: 5.w,
                              onPressed: () {
                                Get.offAll(SignUp());
                              },
                              child: Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          LoginWithEmail();
                        },
                        child: Center(
                          child: Container(
                            height: 6.h,
                            width: 67.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xff41035E),
                                borderRadius: BorderRadius.circular(33.sp)),
                            child: isLoggingIn
                                ? CircularProgressIndicator()
                                : Text(
                                    'Sign In',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mulish(
                                      fontSize: 17.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> LoginWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill out all fields',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return;
    }
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
    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 8 characters long',
        backgroundColor: const Color.fromARGB(255, 252, 39, 24),
        colorText: Colors.white,
      );
      return;
    }
    try {
      setState(() {
        isLoggingIn = true;
      });

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        Get.snackbar(
          'Success',
          'Please check your email to verify your account',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else if (user != null && user.emailVerified) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        bool userExists = userDoc.exists;
        if (!userExists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': emailController.text,
            'userID': user.uid,
            'username': '',
            'userPhotoUrl': ''
          });
          Get.to(AppleInfo());
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userID', user.uid);
          await prefs.setString('userEmail', user.email ?? '');

          Get.snackbar(
            'Success',
            'Sign In Successful',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          if ((userDoc['username'] == null || userDoc['username'].isEmpty) ||
              (userDoc['userPhotoUrl'] == null ||
                  userDoc['userPhotoUrl'].isEmpty)) {
            Get.to(AppleInfo());
          } else {
            Get.to(DashboardScreen());
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userID', user.uid);
          await prefs.setString('userEmail', user.email ?? '');

          Get.snackbar(
            'Success',
            'Sign In Successful',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email' || e.code == 'wrong-password') {
          Get.snackbar(
            'Login Failed',
            'Invalid credentials or User account does not exist',
            backgroundColor: const Color.fromARGB(255, 252, 39, 24),
            colorText: Colors.white,
          );
        }
      }
    } finally {
      setState(() {
        isLoggingIn = false;
      });
    }
  }
}
