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

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
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
                  'Terms and Conditions',
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
          width: 85.w,
          child: Text(
            'Welcome to the Car 3D Modeling Application Modula developed by Disruptive Ai. By using the App, you agree to these Terms and Conditions. Please read them carefully before proceeding: \n\nLicense: Disruptive Ai grants you a non-exclusive, non-transferable, revocable license to use the App for personal, non-commercial purposes only. This license does not grant you any ownership rights to the App.\n\nRestrictions: You agree not to: \n• Modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any part of the App. \n• Use the App for any illegal, unauthorized, or harmful purpose. \n• Circumvent any technical measures we implement to protect the App. \n\nIntellectual Property Rights. \n• The App, including its design, code, features, and content, is the property of Disruptive Ai and protected by intellectual property laws. You agree not to copy, reproduce, or modify the App or any part thereof without our explicit permission.\n\nDisclaimer of Warranties: \n• The App is provided "as is" without any warranties or guarantees, express or implied. Disruptive Ai disclaims all warranties, including but not limited to merchantability, fitness for a particular purpose, and non-infringement.\n• We do not warrant that the App will be error-free, uninterrupted, or free from viruses or other harmful components. Your use of the App is at your own risk.\n\nTermination We reserve the right to suspend or terminate your access to the App at any time without prior notice if you violate these Terms and Conditions.\n\nBy using the App, you agree to these Terms and Conditions. If you do not agree with any part of these terms, please refrain from using the App.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.mulish(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w400,
              height: 0.14.h,
              letterSpacing: 0.2,
              color: Color.fromARGB(174, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }
}
