// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
//import 'package:kf_drawer/kf_drawer.dart';
import 'package:modula/Model/widgets/AppBar.dart';
import 'package:modula/Views/Drawer/Drawer.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:modula/Model/widgets/AppBar.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(
                builder: (context) => SizedBox(
                  width: 5.w,
                  child: MaterialButton(
                    minWidth: 5.h,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Image.asset("assets/menu.png"),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Carvo X',
                  style: GoogleFonts.mulish(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 4.h,
                height: 4.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(userPhotoUrl),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.01, 0.4, 0.9],
              colors: [
                Colors.black,
                Color.fromARGB(255, 65, 3, 94),
                Colors.black,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 6.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                      child: CircleAvatar(
                    radius: 40.sp,
                    backgroundColor: Color.fromARGB(28, 255, 255, 255),
                    child: CircleAvatar(
                      radius: 37.sp,
                      backgroundColor: Color.fromARGB(37, 255, 255, 255),
                    ),
                  )),
                  Container(
                    width: 47.sp,
                    height: 47.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(userPhotoUrl),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 6.h),
              Center(
                child: Container(
                  width: 60.w,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email Address:',
                              style: GoogleFonts.mulish(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              email,
                              style: GoogleFonts.mulish(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            child: Divider(
                          color: const Color.fromARGB(130, 255, 255, 255),
                          thickness: 3.sp,
                          height: 3.h,
                        )),
                        SizedBox(height: 2.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username:',
                              style: GoogleFonts.mulish(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              username,
                              style: GoogleFonts.mulish(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            child: Divider(
                          color: const Color.fromARGB(130, 255, 255, 255),
                          thickness: 3.sp,
                          height: 3.h,
                        )),
                      ]),
                ),
              )
            ],
          )),
    );
  }
}
