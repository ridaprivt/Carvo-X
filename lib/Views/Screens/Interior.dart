// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:modula/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewInteriorImagePage extends StatefulWidget {
  final String directoryPath;

  ViewInteriorImagePage({required this.directoryPath});

  @override
  State<ViewInteriorImagePage> createState() => _ViewInteriorImagePageState();
}

class _ViewInteriorImagePageState extends State<ViewInteriorImagePage> {
  final ProfileController profileController = Get.put(ProfileController());

  final outputPath = Get.find<OutputPathController>().outputPath;

  @override
  Widget build(BuildContext context) {
    final imagePath = '${widget.directoryPath}/interior.jpg';

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
    return imagePath != null
        ? PhotoView(
            imageProvider: FileImage(File(imagePath)),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained * 2.0,
          )
        : Text(
            'No interior image available',
            style: GoogleFonts.mulish(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          );
  }
}
