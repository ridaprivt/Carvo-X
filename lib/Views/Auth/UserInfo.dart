import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modula/Views/Auth/signin_screen.dart';
import 'package:modula/Views/Screens/dashboard_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppleInfo extends StatefulWidget {
  const AppleInfo({super.key});

  @override
  State<AppleInfo> createState() => _AppleInfoState();
}

class _AppleInfoState extends State<AppleInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _image;
  bool post = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String extension = image.path.split('.').last;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$fileName.$extension');
    final result = await ref.putFile(image);
    return await result.ref.getDownloadURL();
  }

  Future<void> saveUserData(String name, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userID') ?? 'unknown';
    final usersRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await usersRef.update({
      'username': name,
      'userPhotoUrl': imageUrl,
    });
    await prefs.setString('userName', name ?? ''); // Storing user name
    await prefs.setString('userPhotoUrl', imageUrl ?? '');
  }

  Future<void> proceed() async {
    if (_image == null || _nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a picture and enter your full name.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      post = true;
    });
    final prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      if (_image != null) {
        final imageUrl = await uploadImage(_image!);
        await saveUserData(name, imageUrl);
        await prefs.setString('userPhotoUrl', imageUrl);
        await prefs.setString('userName', name);
        setState(() {
          post = false;
        });
        Get.offAll(DashboardScreen());
      }
    }
    setState(() {
      post = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear();
                          await GoogleSignIn().signOut();
                          Get.offAll(SignIn());
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 28.w),
                      Text(
                        'Profile',
                        style: GoogleFonts.mulish(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: _image != null
                        ? CircleAvatar(
                            radius: 40.sp, // This will give a diameter of 55.sp
                            backgroundImage: FileImage(_image!),
                          )
                        : Container(
                            width: 55.sp,
                            height: 55.sp,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt,
                                size: 30.sp, color: Colors.grey[500]),
                          ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: pickImage,
                      child: Text('Add Profile Picture',
                          style: GoogleFonts.mulish(fontSize: 17.sp)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 65, 3, 94),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.sp, vertical: 15.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.mulish(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      labelStyle: GoogleFonts.mulish(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: proceed,
                      child: post
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Proceed',
                              style: GoogleFonts.mulish(fontSize: 18.sp)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 65, 3, 94),
                        padding: EdgeInsets.symmetric(
                            horizontal: 43.sp, vertical: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
