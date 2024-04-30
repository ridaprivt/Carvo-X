// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:modula/Views/Screens/Privacy.dart';
import 'package:modula/Views/Screens/Profile.dart';
import 'package:modula/Views/Screens/TermsCondition.dart';
import 'package:modula/Views/Screens/dashboard_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _accountName = '';
  String _accountEmail = '';
  final ProfileController profileController = Get.put(ProfileController());

  void init() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        setState(() {
          _accountName = userData['username'];
          _accountEmail = userData['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 80.w,
      backgroundColor: Color.fromARGB(255, 37, 2, 54),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            height: 100.h,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 0.15, 0.9],
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36.5.sp,
                        backgroundColor: Color.fromARGB(28, 255, 255, 255),
                        child: CircleAvatar(
                            radius: 33.sp,
                            backgroundColor: Color.fromARGB(37, 255, 255, 255),
                            child: CircleAvatar(
                              radius: 29.sp,
                              backgroundColor:
                                  Color.fromARGB(52, 255, 255, 255),
                            )),
                      ),
                      Obx(() {
                        final image = profileController.image.value;
                        if (image != null) {
                          return Container(
                            width: 9.h,
                            height: 9.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(image!.path)),
                              ),
                            ),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 4.5.h,
                            child: Image.asset("assets/pfp.png"),
                          );
                        }
                      }),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(_accountName,
                      style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
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
                    onTap: () {},
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
