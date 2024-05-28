import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modula/Views/Screens/ViewModels.dart';
import 'package:modula/main.dart';
import 'dart:io';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:modula/Controller/Controllers.dart';

class CameraOverlayScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<String> directories;
  final String? directoryName;

  const CameraOverlayScreen({
    Key? key,
    required this.camera,
    required this.directories,
    required this.directoryName,
  }) : super(key: key);

  @override
  _CameraOverlayScreenState createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends State<CameraOverlayScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _showOverlay = true;
  bool _isSaving = false;
  final ViewInteriorImageController viewInteriorImageController =
      Get.find<ViewInteriorImageController>();
  final DirectoryNameController directoryNameController =
      Get.put(DirectoryNameController());

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  // Add a state variable to manage the visibility of the progress indicator

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  height: 100.h,
                  width: 100.w,
                ),
                Center(child: CameraPreview(_controller)),
                if (_showOverlay)
                  Center(
                    child: Image.asset(
                      'assets/front.png',
                      height: 38.h,
                      color: Colors.white,
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.sp),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 65, 3, 94),
          onPressed: _isSaving
              ? null
              : () async {
                  try {
                    setState(() {
                      _isSaving = true; // Start showing the progress indicator
                    });

                    await _initializeControllerFuture;
                    final image = await _controller.takePicture();

                    final outputPath =
                        Get.find<OutputPathController>().outputPath;

                    final finalPath = '$outputPath/${widget.directoryName}/';
                    final imageName = 'captured_image.jpg';
                    final imagePath = '$finalPath$imageName';
                    directoryNameController
                        .setDirectoryName(widget.directoryName ?? '');

                    final File newImage =
                        await File(image.path).copy(imagePath);

                    await ImageGallerySaver.saveFile(newImage.path);

                    setState(() {
                      _isSaving = false; // Stop showing the progress indicator
                    });
                    viewInteriorImageController.setcapture(imagePath);

                    print('Image saved successfully');
                    await Get.to(InteriorDirectorySelectionPage(
                        directories: widget.directories));
                  } catch (e) {
                    setState(() {
                      _isSaving = false; // Stop showing the progress indicator
                    });

                    print('Error while saving image: $e');
                  }
                },
          child: _isSaving
              ? CircularProgressIndicator(
                  color: Colors.white,
                ) // Show the progress indicator
              : Icon(
                  Icons.camera,
                  size: 30,
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
