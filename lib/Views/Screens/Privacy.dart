// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
//import 'package:kf_drawer/kf_drawer.dart';
import 'package:modula/Model/widgets/AppBar.dart';
import 'package:modula/Views/Drawer/Drawer.dart';
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

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  final ProfileController profileController = Get.put(ProfileController());

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
                  'Privacy',
                  style: GoogleFonts.mulish(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Obx(() {
                  final image = profileController.image.value;
                  if (image != null) {
                    return Container(
                      width: 4.h,
                      height: 4.h,
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
                      radius: 2.h,
                      child: Image.asset("assets/pfp.png"),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.only(top: 10.h),
        alignment: Alignment.topCenter,
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
        child: Container(
          width: 80.w,
          child: Text.rich(
            TextSpan(
              style: GoogleFonts.mulish(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                height: 0.12.h,
                letterSpacing: 0.5,
                color: Color.fromARGB(174, 255, 255, 255),
              ),
              children: [
                TextSpan(
                  text:
                      'We value your privacy and are committed to safeguarding your personal information when you use our Car 3D Modeling Application Modula.\n\n',
                  style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'Here\'s how we handle your data:\n\n',
                  style: GoogleFonts.mulish(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'Information We Collect: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'We may collect personal information (name, email) and usage data (IP address, device info) to improve the App\'s performance.\n\n',
                ),
                TextSpan(
                  text: 'How We Use Your Information: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'We use your data to personalize your experience, respond to inquiries, and enhance the App\'s features.\n\n',
                ),
                TextSpan(
                  text: 'Information Sharing: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'We don\'t sell your data. Trusted third-party providers may assist us, and we may disclose data if required by law.\n\n',
                ),
                TextSpan(
                  text: 'Data Security: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'We implement reasonable measures to protect your information, but remember no method is 100% secure.\n\n',
                ),
                TextSpan(
                  text: 'Children\'s Privacy: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'The App is not intended for children under 16. We don\'t knowingly collect data from minors without parental consent.\n\n',
                ),
                TextSpan(
                  text: 'Changes to Policy: ',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'We may update this policy, and the latest version will be posted with an updated date. If you have questions or concerns, contact us at disruptiveai@outlook.com. By using the App, you agree to this policy.',
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
