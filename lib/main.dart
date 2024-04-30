// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modula/Views/Screens/SplashScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:modula/Controller/Controllers.dart';

void main() async {
  final String outputPath = '/storage/emulated/0/Download/.FrameExtracted/';

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(OutputPathController(outputPath));
  Get.put(ViewInteriorImageController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    });
  }
}
