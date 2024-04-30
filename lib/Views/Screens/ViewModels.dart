// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';
import 'Model360.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class InteriorDirectorySelectionPage extends StatefulWidget {
  final List<String> directories;

  InteriorDirectorySelectionPage({required this.directories});

  @override
  _InteriorDirectorySelectionPageState createState() =>
      _InteriorDirectorySelectionPageState();
}

class _InteriorDirectorySelectionPageState
    extends State<InteriorDirectorySelectionPage> {
  final ProfileController profileController = Get.put(ProfileController());

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String directoryPath) async {
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
          'Delete Model',
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this model?',
          style: GoogleFonts.mulish(
            fontSize: 14.sp,
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
              final directory = Directory(directoryPath);
              await directory.delete(recursive: true);

              // After deleting the directory, trigger a page reload using setState.
              setState(() {
                widget.directories.remove(directoryPath);
              });
            },
            child: Container(
              width: 17.w,
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
                'Yes',
                style: GoogleFonts.mulish(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          MaterialButton(
            minWidth: 10.w,
            onPressed: () => Navigator.pop(context),
            child: Container(
              width: 16.w,
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
                'No',
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
            stops: [0.01, 0.15, 0.9],
            colors: [
              Colors.black,
              Color.fromARGB(255, 65, 3, 94),
              Colors.black,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: widget.directories.length,
          itemBuilder: (context, index) {
            final directoryPath = widget.directories[index];
            final directory = Directory(directoryPath);
            final files = directory.listSync();
            final imageFiles = files
                .where((file) =>
                    file is File && file.path.toLowerCase().endsWith('.png'))
                .toList();
            final directoryName = directoryPath.split('/').last;

            if (imageFiles.isEmpty) {
              return SizedBox
                  .shrink(); // Skip rendering if the directory has no image files
            }

            final imageFile = imageFiles.first as File?;

            return GestureDetector(
              onTap: () {
                if (imageFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          Complete360ViewPage(directoryPath: directoryPath),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No Image Found'),
                      content: Text('No image found in this directory.'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  Container(
                    height: 30.h,
                    width: double.infinity,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 98, 98, 98)
                              .withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
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
                    child: Stack(
                      children: [
                        if (imageFile != null)
                          Positioned.fill(
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Center(
                            child: Text(
                              'No Image',
                              style: GoogleFonts.mulish(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(12.sp),
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
                            child: IconButton(
                              onPressed: () => _showDeleteConfirmationDialog(
                                  context, directoryPath),
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40.w,
                    height: 5.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(172, 52, 1, 52),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(colors: [
                            Color(0xff41035E),
                            Color(0xff003D78),
                            Color(0xff003D78)
                          ]),
                          width: 5.sp,
                        ),
                        borderRadius: BorderRadius.circular(13.sp)),
                    child: Text(
                      'Model Name: ' + directoryName,
                      style: GoogleFonts.mulish(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
