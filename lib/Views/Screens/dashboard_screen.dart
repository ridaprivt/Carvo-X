// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modula/Views/Drawer/Drawer.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modula/Views/Screens/ViewAll.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CameraOverlay.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final outputPath = Get.find<OutputPathController>().outputPath;
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List imagePath = [
    'assets/car1.jpg',
    'assets/car2.jpeg',
    'assets/car3.jpeg',
    'assets/car4.jpeg',
    'assets/car5.jpeg',
  ];
  final ProfileController profileController = Get.put(ProfileController());
  File? _selectedVideo;
  String? _directoryName;
  bool _isExtractingFrames = false;
  List<String> _directories = [];
  TextEditingController _fpsController = TextEditingController();
  double _fpsValue = 1.0;

  List<File?> _selectedImages = List.generate(11, (_) => null);
  final ImagePicker _imagePicker = ImagePicker();

  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID') ?? '';

    if (userID.isEmpty) {
      print('User ID not found');
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userID).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        email = userData['email'] ?? "No email provided";
        username = userData['username'] ?? "No username provided";
        userPhotoUrl = userData['userPhotoUrl'] ?? "No photo URL provided";
      });

      print('Email: $email');
      print('Username: $username');
      print('Photo URL: $userPhotoUrl');
    } else {
      print('User not found');
    }
  }

  Future<void> _chooseFromGallery() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  Future<void> _recordVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  Future<void> _showVideoSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Select Video Source',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                _chooseFromGallery();
              },
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
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
                    'Choose from Gallery',
                    style: GoogleFonts.mulish(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                _recordVideo();
              },
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
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
                    'Record Video',
                    style: GoogleFonts.mulish(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _bgremove_or_not() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Do you want to',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _showFPSDialog();
              },
              child: Center(
                child: Container(
                  width: 90.w,
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
                    'With Background Removal',
                    style: GoogleFonts.mulish(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _showFPSDialog2();
              },
              child: Center(
                child: Container(
                  width: 90.w,
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
                    'Without Background Removal',
                    style: GoogleFonts.mulish(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFPSDialog() async {
    final textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Enter FPS (out of 30)',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _fpsController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(172, 255, 255, 255),
            ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(95, 255, 255, 255),
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(95, 255, 255, 255),
              )),
              hintText: 'FPS',
              hintStyle: GoogleFonts.mulish(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(172, 255, 255, 255),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'For optimal result, choose frame <10 \nFor better result, record video>= 40 sec',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ]),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                _fpsValue = double.tryParse(textEditingController.text) ?? 1.0;
              });
              Navigator.pop(context);
              _showDirectoryNameDialog();
            },
            child: Container(
              width: 14.w,
              height: 4.h,
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
                'OK',
                style: GoogleFonts.mulish(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFPSDialog2() async {
    final textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Enter FPS (out of 30)',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _fpsController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(172, 255, 255, 255),
            ),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(95, 255, 255, 255),
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(95, 255, 255, 255),
              )),
              hintText: 'FPS',
              hintStyle: GoogleFonts.mulish(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(172, 255, 255, 255),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'For optimal result, choose frame <10 \nFor better result, record video>= 40 sec',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ]),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                _fpsValue = double.tryParse(textEditingController.text) ?? 1.0;
              });
              Navigator.pop(context);
              _showDirectoryNameDialog2();
            },
            child: Container(
              width: 14.w,
              height: 4.h,
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
                'OK',
                style: GoogleFonts.mulish(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDirectoryNameDialog() async {
    final textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Enter Project Name',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: TextField(
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          controller: textEditingController,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(95, 255, 255, 255),
            )),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(95, 255, 255, 255),
            )),
            hintText: 'Project Name',
            hintStyle: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(198, 255, 255, 255),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              setState(() {
                _directoryName = textEditingController.text;
              });
              Navigator.pop(context);
              _extractFrames();
            },
            child: Container(
              width: 14.w,
              height: 4.h,
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
                'OK',
                style: GoogleFonts.mulish(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDirectoryNameDialog2() async {
    final textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Enter Project Name',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: TextField(
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          controller: textEditingController,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(95, 255, 255, 255),
            )),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(95, 255, 255, 255),
            )),
            hintText: 'Project Name',
            hintStyle: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(198, 255, 255, 255),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              setState(() {
                _directoryName = textEditingController.text;
              });
              Navigator.pop(context);
              _extractFrames2();
            },
            child: Container(
              width: 14.w,
              height: 4.h,
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
                'OK',
                style: GoogleFonts.mulish(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkDirectoryExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    return directory.exists();
  }

  Future<void> _extractFrames() async {
    if (_selectedVideo == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'No Video Selected',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Please select a video file first.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 14.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (_directoryName == null || _directoryName!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Project Name'),
          content: Text('Please enter a project name first.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isExtractingFrames = true;
    });

    final outputPath = '${widget.outputPath}/$_directoryName/';

    final directoryExists = await _checkDirectoryExists(outputPath);
    if (directoryExists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Project Already Exists',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'A directory with the same name already exists. Do you want to overwrite it?',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteExistingDirectoryAndExtractFrames2(outputPath);
              },
              child: Container(
                width: 17.w,
                height: 4.h,
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
                  'Overwrite',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _showDirectoryNameDialog();
              },
              child: Container(
                width: 17.w,
                height: 4.h,
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
                  'Rename',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        _isExtractingFrames = false;
      });
      return;
    }

    final outputDirectory = Directory(outputPath);
    await outputDirectory.create(recursive: true);

    final session = await FFmpegKit.execute(
        '-i ${_selectedVideo!.path} -vf "fps=$_fpsValue" ${outputPath}%1d.png');
    final returnCode = await session.getReturnCode();

    setState(() {
      _isExtractingFrames = false;
    });

    if (ReturnCode.isSuccess(returnCode)) {
      setState(() {
        _isExtractingFrames = false;
      });

      // Perform background removal on the frames and save them in the same directory
      List<File> frames = await _getExtractedFrames(outputPath);
      await _processImages(frames);

      await _updateDirectoriesList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Extraction Complete',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Frames extracted successfully.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _generate_interior();
              },
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'Proceed',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (ReturnCode.isCancel(returnCode)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Extraction Cancelled',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'The frame extraction process was cancelled.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Extraction Failed',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'An error occurred during frame extraction.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _extractFrames2() async {
    if (_selectedVideo == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'No Video Selected',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Please select a video file first.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 14.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (_directoryName == null || _directoryName!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'No Project Name',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Please enter a project name first.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 14.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isExtractingFrames = true;
    });

    final outputPath = '${widget.outputPath}/$_directoryName/';

    final directoryExists = await _checkDirectoryExists(outputPath);
    if (directoryExists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Project Already Exists',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'A directory with the same name already exists. Do you want to overwrite it?',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteExistingDirectoryAndExtractFrames2(outputPath);
              },
              child: Container(
                width: 17.w,
                height: 4.h,
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
                  'Overwrite',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _showDirectoryNameDialog();
              },
              child: Container(
                width: 17.w,
                height: 4.h,
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
                  'Rename',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        _isExtractingFrames = false;
      });
      return;
    }

    final outputDirectory = Directory(outputPath);
    await outputDirectory.create(recursive: true);

    final session = await FFmpegKit.execute(
        '-i ${_selectedVideo!.path} -vf "fps=$_fpsValue" ${outputPath}%1d.png');
    final returnCode = await session.getReturnCode();

    setState(() {
      _isExtractingFrames = false;
    });

    if (ReturnCode.isSuccess(returnCode)) {
      setState(() {
        _isExtractingFrames = false;
      });

      // Perform background removal on the frames and save them in the same directory

      await _updateDirectoriesList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Extraction Complete',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Frames extracted successfully.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                _generate_interior();
              },
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'Proceed',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (ReturnCode.isCancel(returnCode)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Extraction Cancelled',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'The frame extraction process was cancelled.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff41035E),
                width: 4.sp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.sp))),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Extraction Failed',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'An error occurred during frame extraction.',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 15.w,
                height: 4.h,
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
                  'OK',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

//interior//
  Future<void> _generate_interior() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Text(
          'Do you want to generate interior?',
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () async {
              Navigator.pop(context);
              _showImageSourceDialog();
            },
            child: Container(
              width: 16.w,
              height: 4.h,
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
                'Yes',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: 10.w,
            onPressed: () {
              Navigator.pop(context);
              _generate_parts();
            },
            child: Container(
              width: 16.w,
              height: 4.h,
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
                'Skip',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.sp),
        ),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Text(
          'Select Image Source',
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _captureInteriorImage(ImageSource.camera);
              },
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
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
                    'Capture From Camera',
                    style: GoogleFonts.mulish(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _captureInteriorImage(ImageSource.gallery);
              },
              child: Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
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
                    'Select From Gallery',
                    style: GoogleFonts.mulish(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureInteriorImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final outputPath = '${widget.outputPath}/$_directoryName/';
      final interiorPath = '$outputPath/interior.jpg';
      final File capturedImage = File(pickedFile.path);
      await capturedImage.copy(interiorPath);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.sp),
          ),
          backgroundColor: Color.fromARGB(255, 23, 1, 34),
          title: Text(
            'Image Saved Successfully',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Do you want to proceed?',
            style: GoogleFonts.mulish(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(154, 255, 255, 255),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
                _generate_parts();
              },
              child: Container(
                width: 17.w,
                height: 4.h,
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
                  borderRadius: BorderRadius.circular(13.sp),
                ),
                child: Text(
                  'Proceed',
                  style: GoogleFonts.mulish(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

//parts//

  Future<void> _generate_parts() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Text(
          'Do you want to generate parts?',
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () async {
              Navigator.pop(context);
              _interior_pictures();
            },
            child: Container(
              width: 16.w,
              height: 4.h,
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
                'Yes',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: 10.w,
            onPressed: () {
              _capture_exterior();
            },
            child: Container(
              width: 16.w,
              height: 4.h,
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
                'Skip',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getImage(int index, ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      final carPartName = getCarPartName(index);
      final fileName = '$carPartName.jpg';
      final outputPath = '${widget.outputPath}/$_directoryName/';

      final selectedImage = File(pickedImage.path);
      final savedImage = await selectedImage.copy('$outputPath/$fileName');

      setState(() {
        _selectedImages[index] = savedImage;
      });
    }
  }

  Future<void> _interior_pictures() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Center(
          child: Text(
            'Choose Pictures',
            style: GoogleFonts.mulish(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 95.w,
              child: ListView.builder(
                itemCount: 11,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedImages[index] != null;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16.sp,
                        backgroundColor: Color.fromARGB(255, 70, 14, 80),
                        backgroundImage: isSelected
                            ? FileImage(_selectedImages[index]!)
                            : null,
                        child:
                            isSelected ? null : Icon(Icons.image, size: 16.sp),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        getCarPartName(index),
                        style: GoogleFonts.mulish(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 16.sp,
                          color: Colors.green,
                        ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.photo_library,
                          size: 17.sp,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _getImage(index, ImageSource.gallery);
                          setState(() {}); // Update UI after selecting image
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.camera_alt,
                          size: 17.sp,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _getImage(index, ImageSource.camera);
                          setState(() {}); // Update UI after selecting image
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _selectedImages = List.generate(8, (_) => null);
              });
              _capture_exterior();
              //Get.to(InteriorDirectorySelectionPage(directories: _directories));
            },
            child: Container(
              width: 16.w,
              height: 4.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(153, 52, 1, 52),
                border: GradientBoxBorder(
                  gradient: LinearGradient(colors: [
                    Color(0xff41035E),
                    Color(0xff003D78),
                    Color(0xff003D78),
                  ]),
                  width: 6.sp,
                ),
                borderRadius: BorderRadius.circular(13.sp),
              ),
              child: Text(
                'Proceed',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capture_exterior() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff41035E),
              width: 4.sp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.sp))),
        backgroundColor: Color.fromARGB(255, 23, 1, 34),
        title: Text(
          'Capture exterior to proceed',
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          MaterialButton(
            minWidth: 10.w,
            padding: EdgeInsets.all(0),
            onPressed: () async {
              Navigator.pop(context);
              Get.to(CameraOverlayScreen(
                camera: firstCamera,
                directories: _directories,
                directoryName: _directoryName,
              ));
            },
            child: Container(
              width: 16.w,
              height: 4.h,
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
                'Continue',
                style: GoogleFonts.mulish(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//parts//
  Future<void> _deleteExistingDirectoryAndExtractFrames(
      String directoryPath) async {
    final Directory directory = Directory(directoryPath);

    if (directory.existsSync()) {
      setState(() {
        _isExtractingFrames = true;
      });

      await directory.delete(recursive: true);

      setState(() {
        _isExtractingFrames = false;
      });

      setState(() {
        _isExtractingFrames = true;
      });

      await _extractFrames();

      setState(() {
        _isExtractingFrames = false;
      });
    }
  }

  Future<void> _deleteExistingDirectoryAndExtractFrames2(
      String directoryPath) async {
    final Directory directory = Directory(directoryPath);

    if (directory.existsSync()) {
      setState(() {
        _isExtractingFrames = true;
      });

      await directory.delete(recursive: true);

      setState(() {
        _isExtractingFrames = false;
      });

      setState(() {
        _isExtractingFrames = true;
      });

      await _extractFrames2();

      setState(() {
        _isExtractingFrames = false;
      });
    }
  }

  Future<List<File>> _getExtractedFrames(String directoryPath) async {
    List<File> frames = [];
    final directory = Directory(directoryPath);
    final files = directory.listSync();
    for (var file in files) {
      if (file is File && file.path.toLowerCase().endsWith('.png')) {
        frames.add(file);
      }
    }
    return frames;
  }

  Future<void> _processImages(List<File> images) async {
    for (int i = 0; i < images.length; i++) {
      File selectedImage = images[i];

      setState(() {
        _isExtractingFrames = true; // Show CircularProgressIndicator
      });

      final url =
          "https://remove-background-image2.p.rapidapi.com/remove-background";
      final headers = {
        "X-RapidAPI-Key": "81155407b8msh52748ada5fa659dp122257jsne4d9decc4036",
        "X-RapidAPI-Host": "remove-background-image2.p.rapidapi.com"
      };

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      var file = await http.MultipartFile.fromPath('file', selectedImage.path);
      request.files.add(file);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = utf8.decode(responseData);
        var data = json.decode(responseString);
        var status = data['status'];

        if (status) {
          var image = data['image'];
          var imageBytes = base64.decode(image);
          await selectedImage.writeAsBytes(imageBytes);
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }

      setState(() {
        _isExtractingFrames = false; // Hide CircularProgressIndicator
      });
    }
  }

  Future<void> _updateDirectoriesList() async {
    final directory = Directory(widget.outputPath);
    final directories = directory
        .listSync()
        .whereType<Directory>()
        .map((dir) => dir.path)
        .toList();

    setState(() {
      _directories = directories;
    });
  }

  Future<void> _showAllDirectories() async {
    final directory = Directory(widget.outputPath);
    final directories = directory
        .listSync()
        .whereType<Directory>()
        .map((dir) => dir.path)
        .toList();

    print(directories);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllDirectoriesPage(directories: directories),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          drawer: MyDrawer(),
          body: Container(
            height: 100.h,
            width: 100.w,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.sp),
                        bottomRight: Radius.circular(25.sp),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Swiper(
                            itemWidth: 100
                                .w, // Increase the itemWidth to add larger gaps
                            itemHeight: 40.h, // Adjust this value as needed
                            loop: true,
                            indicatorLayout: PageIndicatorLayout.SCALE,
                            duration: 400,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(imagePath[index]),
                                    ),
                                    borderRadius: BorderRadius.circular(20.sp),
                                    border: Border.all(color: Colors.black)),
                              );
                            },
                            itemCount: imagePath.length,
                            layout: SwiperLayout.TINDER,
                            viewportFraction: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Divider(
                    height: 3.h,
                    color: const Color.fromARGB(151, 255, 255, 255),
                    thickness: 0.5,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.mulish(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(username + "!",
                      style: GoogleFonts.mulish(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text('''Step into the world of Immersive Car Visuals:
Capture,Customize,and Showcase in 360°

With a simple video recording of the vehicle's interior and exterior, Carvo X's amazing algorithm processes the video to create a visually appealing and interactive 3D model representation
''',
                      style: GoogleFonts.mulish(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  MaterialButton(
                    onPressed: () {
                      BottomSheet(context);
                    },
                    child: Center(
                      child: Container(
                        width: 63.w,
                        height: 7.5.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(116, 52, 1, 52),
                            border: GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Color(0xff41035E),
                                Color(0xff003D78),
                                Color(0xff003D78)
                              ]),
                              width: 4.sp,
                            ),
                            borderRadius: BorderRadius.circular(13.sp)),
                        child: Text(
                          'CREATE 3D MODEL',
                          style: GoogleFonts.mulish(
                            fontSize: 17.5.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<dynamic> BottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.black,
      elevation: 10,
      context: context,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.sp),
          topRight: Radius.circular(35.sp),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 50.h,
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: LinearGradient(colors: [
                Color(0xff41035E),
                Color(0xff003D78),
                Color(0xff003D78)
              ]),
              width: 6.sp,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.sp),
              topRight: Radius.circular(22.sp),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.3, 0.9],
              colors: [
                Colors.black,
                Color.fromARGB(175, 65, 3, 94),
                Colors.black,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    _showVideoSourceDialog();
                  },
                  child: Center(
                    child: Container(
                      width: 57.w,
                      height: 6.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(153, 52, 1, 52),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                            Color(0xff41035E),
                            Color(0xff003D78),
                            Color(0xff003D78),
                          ]),
                          width: 6.sp,
                        ),
                        borderRadius: BorderRadius.circular(13.sp),
                      ),
                      child: Text(
                        'Select Video',
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: Text(
                    (_selectedVideo != null
                        ? 'Video Selected'
                        : 'No Video Selected'),
                    style: GoogleFonts.mulish(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                MaterialButton(
                  onPressed: () => _bgremove_or_not(),
                  child: Center(
                    child: Container(
                      width: 57.w,
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
                        'Generate',
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: Text(
                    _directoryName != null
                        ? 'Project Name: $_directoryName'
                        : 'No Project Name',
                    style: GoogleFonts.mulish(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                if (_isExtractingFrames)
                  Center(
                      child: CircularProgressIndicator(
                    color: Color(0xff41035E),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }

  String getCarPartName(int index) {
    switch (index) {
      case 0:
        return 'Bumper';
      case 1:
        return 'Bonnet';
      case 2:
        return 'Right Head Light';
      case 3:
        return 'Left Head Light';
      case 4:
        return 'Front Tyre Left';
      case 5:
        return 'Front Tyre Right';
      case 6:
        return 'Back Tyre Left';
      case 7:
        return 'Back Tyre Right';
      case 8:
        return 'Left Tail Light';
      case 9:
        return 'Right Tail Light';
      case 10:
        return 'Trunk';
      default:
        return '';
    }
  }
}
