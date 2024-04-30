// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:modula/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Parts.dart';

class Hotspots extends StatefulWidget {
  final String directoryPath;

  Hotspots({required this.directoryPath});

  @override
  State<Hotspots> createState() => _Hotspots();
}

class _Hotspots extends State<Hotspots> {
  final ProfileController profileController = Get.put(ProfileController());

  final outputPath = Get.find<OutputPathController>().outputPath;

  @override
  Widget build(BuildContext context) {
    final imagePath = '${widget.directoryPath}/captured_image.jpg';

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
                  'Carvo X',
                  style: GoogleFonts.mulish(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 30.w),
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
            stops: [0.01, 0.5, 0.97],
            colors: [
              Colors.black,
              Color.fromARGB(255, 65, 3, 94),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: _buildPhotoView(imagePath),
        ),
      ),
    );
  }

  Widget _buildPhotoView(String imagePath) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return imagePath != null
        ? Center(
            child: Stack(
              children: [
                Center(
                  child: PhotoView(
                    imageProvider: FileImage(File(imagePath)),
                    backgroundDecoration: BoxDecoration(color: Colors.black),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/front.png',
                    height: 38.h,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        hotspot('Bonnet'),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            hotspot('Left Head Light'),
                            SizedBox(width: screenWidth * 0.33),
                            hotspot('Right Head Light'),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.07),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            hotspot('Front Tyre Left'),
                            SizedBox(width: screenWidth * 0.37),
                            hotspot('Front Tyre Right'),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : Text(
            'No captured image available',
            style: GoogleFonts.mulish(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          );
  }

  hotspot(String carPartName) {
    return GestureDetector(
      onTap: () {
        print('${widget.directoryPath}/$carPartName.jpg');
        Get.to(Parts(
          carPartName: carPartName,
          directoryPath: widget.directoryPath,
        ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 193, 89, 241),
            radius: 11.sp,
          ),
          SizedBox(height: 0.5.h),
          Container(
              color: Color(0xff41035E),
              padding: EdgeInsets.fromLTRB(8.sp, 2.sp, 8.sp, 2.sp),
              child: Text(
                carPartName,
                style: GoogleFonts.mulish(color: Colors.white, fontSize: 12.sp),
              ))
        ],
      ),
    );
  }
}
