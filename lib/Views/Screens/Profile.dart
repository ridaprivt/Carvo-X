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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imageurl = '';

  String _accountName = '';
  String _accountEmail = '';
  String _phone = '';
  final ProfileController profileController = Get.put(ProfileController());

  Future<void> get_Image() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file;

    try {
      file = await imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking an image: $e');
      return;
    }

    if (file != null) {
      profileController.setImage(file); // Use the controller to set the image
    } else {
      print('No image selected.');
      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageurl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageurl');
    } catch (e) {
      print('Error uploading image: $e');
    }
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
          _phone = userData['mobileNo'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fetchUserDetails();
    }
  }

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
                        radius: 35.sp,
                        backgroundColor: Color.fromARGB(37, 255, 255, 255),
                        child: CircleAvatar(
                          radius: 30.sp,
                          backgroundColor: Color.fromARGB(52, 255, 255, 255),
                        )),
                  )),
                  Center(child: Obx(() {
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
                        child: Image.asset(
                          "assets/pfp.png",
                        ),
                      );
                    }
                  })),
                ],
              ),
              SizedBox(height: 3.h),
              MaterialButton(
                onPressed: get_Image,
                child: Center(
                  child: Container(
                    width: 40.w,
                    height: 6.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(153, 52, 1, 52),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                            Color(0xff41035E),
                            Color(0xff003D78),
                            Color(0xff003D78)
                          ]),
                          width: 6.sp,
                        ),
                        borderRadius: BorderRadius.circular(13.sp)),
                    child: Text(
                      'Edit Profile Picture',
                      style: GoogleFonts.mulish(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
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
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _accountEmail,
                              style: GoogleFonts.mulish(
                                fontSize: 15.sp,
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
                          children: [
                            Text(
                              'Username:',
                              style: GoogleFonts.mulish(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _accountName,
                              style: GoogleFonts.mulish(
                                fontSize: 15.sp,
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
                          children: [
                            Text(
                              'Phone Number:',
                              style: GoogleFonts.mulish(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _phone,
                              style: GoogleFonts.mulish(
                                fontSize: 15.sp,
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
