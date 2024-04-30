// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:imageview360/imageview360.dart';
import 'package:modula/Views/Screens/Hotspots.dart';
import 'package:modula/Views/Screens/ModelParts.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'Interior.dart';

class Complete360ViewPage extends StatefulWidget {
  final String directoryPath;

  Complete360ViewPage({required this.directoryPath});

  @override
  _Complete360ViewPageState createState() => _Complete360ViewPageState();
}

class _Complete360ViewPageState extends State<Complete360ViewPage> {
  List<ImageProvider> imageList = [];
  bool imagePrecached = false;
  double _scale = 1.0;
  double _previousScale = 1.0;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => updateImageList());
  }

  void updateImageList() async {
    String directoryPath = widget.directoryPath;

    final framesDirectory = Directory(directoryPath);
    final files = framesDirectory.listSync();

    for (var file in files) {
      if (file is File) {
        String imagePath = file.path;
        if (imagePath.toLowerCase().endsWith('.png')) {
          print('Image exists: $imagePath');
          imageList.add(FileImage(file));
          await precacheImage(FileImage(file), context);
        }
      }
    }

    setState(() {
      imagePrecached = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double imageViewWidth = 100.w; // Your desired width
    final double imageViewHeight = 100.h; // Your desired height

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
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
          setState(() {});
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          _scale = _previousScale * details.scale;
          setState(() {});
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = 1.0;
          setState(() {});
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          alignment: Alignment.center,
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
          child: (imagePrecached == true)
              ? Stack(
                  children: [
                    Center(
                      child: Container(
                        width: imageViewWidth,
                        height: imageViewHeight,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Transform.scale(
                            scale: _scale,
                            child: ImageView360(
                              rotationCount: 2,
                              key: UniqueKey(),
                              imageList: imageList,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5.h,
                      right: 3.w,
                      child: Column(children: [
                        MaterialButton(
                          onPressed: () {
                            print(widget.directoryPath);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewInteriorImagePage(
                                    directoryPath: widget.directoryPath),
                              ),
                            );
                          },
                          child: Container(
                            height: 8.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.01, 0.2, 0.5],
                                colors: [
                                  Colors.black,
                                  Color.fromARGB(255, 65, 3, 94),
                                  Colors.black,
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.sp),
                              child: Image.asset(
                                'assets/interiorimg.jpg',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        MaterialButton(
                          onPressed: () {
                            Get.to(Hotspots(
                              directoryPath: widget.directoryPath,
                            ));
                          },
                          child: Container(
                            height: 8.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.01, 0.2, 0.5],
                                colors: [
                                  Colors.black,
                                  Color.fromARGB(255, 65, 3, 94),
                                  Colors.black,
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.sp),
                              child: Image.asset(
                                'assets/parts.jpg',
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
