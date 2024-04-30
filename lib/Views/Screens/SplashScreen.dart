// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modula/Views/Auth/signin_screen.dart';
import 'package:modula/Views/Screens/dashboard_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      checkFirstLaunch();
    });
  }

  @override
  Future<void> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      Get.offAll(DashboardScreen());
    } else {
      Get.offAll(SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img.png'), fit: BoxFit.cover),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.5, 0.75],
                  colors: [
                    Colors.black,
                    Color.fromARGB(255, 65, 3, 94),
                    Colors.black,
                  ],
                )),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Image.asset(
                  'assets/logo.png',
                  width: 80.w,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
