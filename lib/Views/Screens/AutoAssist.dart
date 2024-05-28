// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:modula/Views/Drawer/Drawer.dart';
import 'package:modula/Views/Screens/BotResponse.dart';
import 'package:modula/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class AutoAssist extends StatefulWidget {
  const AutoAssist({super.key});

  @override
  State<AutoAssist> createState() => _AutoAssistState();
}

class _AutoAssistState extends State<AutoAssist> {
  bool _uploading = false;
  TextEditingController bot = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
                  'Auto Assist',
                  style: GoogleFonts.mulish(
                    fontSize: 18.sp,
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.only(top: 5.h),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.01, 0.4, 0.9],
              colors: [
                Colors.black,
                Color.fromARGB(255, 65, 3, 94),
                Colors.black,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            children: [
              Image.asset(
                'assets/ai.png',
                height: 25.h,
              ),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '''Hello, I'm Auto Assist, your personal car expert! Whether you need help choosing a new vehicle, troubleshooting an issue, or just looking for maintenance tips, I'm here to provide you with fast, accurate, and helpful information on all things automotive.''',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    border: Border.all(color: Color(0xffD0DBEA))),
                child: TextField(
                  maxLines: 6,
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.5.sp,
                    color: Colors.white,
                  ),
                  controller: bot,
                  decoration: InputDecoration(
                    hintText: 'How can I assist you today?'.tr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp, vertical: 13.sp),
                    hintStyle: GoogleFonts.mulish(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.5.sp,
                      color: Color(0xff9FA5C0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              InkWell(
                onTap: () {
                  generateResponse();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 13.sp, horizontal: 18.sp),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 3, 94),
                        borderRadius: BorderRadius.circular(25.sp)),
                    child: _uploading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            '    Submit    '.tr,
                            style: GoogleFonts.mulish(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateResponse() async {
    setState(() {
      _uploading = true;
    });

    String prompt = ' Please answer this : ${bot.text}';

    List<Map<String, dynamic>> messages = [
      {'role': 'user', 'content': prompt},
    ];
    final String apiUrl =
        "https://us-central1-chatbot-b81d7.cloudfunctions.net/afnan-gpt";
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    Map<String, dynamic> payload = {
      "data": {"conversation": messages}
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("result") &&
            responseData["result"].containsKey("response")) {
          String solution = responseData["result"]["response"].toString();
          Get.to(BotResponse(ans: solution));
          setState(() {
            print('-------------');
            print(prompt);
            print('GPT RESPONSE: $solution');
          });
        } else {
          print('Unexpected response format.');
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _uploading = false;
    });
  }
}
