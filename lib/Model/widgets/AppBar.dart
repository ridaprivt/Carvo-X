import 'package:flutter/material.dart';
//import 'package:kf_drawer/kf_drawer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:modula/Controller/Controllers.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final ProfileController profileController = Get.put(ProfileController());
// Get the instance of the GetX controller

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 5.w,
              child: MaterialButton(
                minWidth: 5.h,
                padding: EdgeInsets.all(0),
                onPressed: () {},
                //widget.onMenuPressed,
                child: Image.asset("assets/menu.png"),
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
    );
  }
}
