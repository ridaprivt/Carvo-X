// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class Parts extends StatelessWidget {
  final String carPartName;
  final String directoryPath;

  Parts({required this.carPartName, required this.directoryPath});

  final ViewInteriorImageController controller =
      Get.put(ViewInteriorImageController());

  final DirectoryNameController directoryNameController =
      Get.put(DirectoryNameController());

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final outputPath = Get.find<OutputPathController>().outputPath;
    final String imagePath = '$directoryPath/$carPartName.jpg';
    print('$imagePath'); // Construct the image path

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 7.h,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
          child: Row(
            children: [
              Spacer(),
              Center(
                child: Text(
                  'Modula',
                  style: GoogleFonts.mulish(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 30.w),
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
            stops: [0.01, 0.5, 0.97],
            colors: [
              Colors.black,
              Color.fromARGB(255, 65, 3, 94),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: imagePath != null
              ? PhotoView(
                  imageProvider: FileImage(File(imagePath)),
                )
              : Text('No image available for this part.'),
        ),
      ),
    );
  }
}
