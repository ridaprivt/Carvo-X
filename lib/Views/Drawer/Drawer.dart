// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:modula/Views/Auth/signin_screen.dart';
import 'package:modula/Views/Screens/Profile.dart';
import 'package:modula/Views/Screens/Privacy.dart';
import 'package:modula/Views/Screens/TermsCondition.dart';
import 'package:modula/Views/Screens/dashboard_screen.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 80.w,
      backgroundColor: Color.fromARGB(255, 37, 2, 54),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            height: 120.h,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 0.1, 0.7],
                  colors: [
                    Colors.black,
                    Color.fromARGB(255, 65, 3, 94),
                    Colors.black,
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.sp), //BoxDecoration
              child: Column(
                children: [
                  Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      radius: 36.5.sp,
                      backgroundColor: Color.fromARGB(28, 255, 255, 255),
                      child: CircleAvatar(
                        radius: 33.sp,
                        backgroundColor: Color.fromARGB(37, 255, 255, 255),
                      ),
                    ),
                    Container(
                      width: 40.sp,
                      height: 40.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(userPhotoUrl),
                        ),
                      ),
                    )
                  ]),
                  SizedBox(height: 1.h),
                  Text(username,
                      style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400))),
                  SizedBox(height: 0.3.h),
                  Text(email,
                      style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700))),
                  SizedBox(height: 3.h),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic1.png',
                      height: 20.sp,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Get.offAll(DashboardScreen());
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic3.png',
                      height: 20.sp,
                    ),
                    title: Text(
                      'Privacy',
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Get.offAll(Privacy());
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic4.png',
                      height: 20.sp,
                    ),
                    title: Text(
                      'Terms and Conditions',
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Get.offAll(TermsConditions());
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/ic5.png',
                      height: 20.sp,
                    ),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(SignIn());
                    },
                  ),
                ],
              ),
            ),
          ), //DrawerHeader
        ],
      ),
    );
  }
}
