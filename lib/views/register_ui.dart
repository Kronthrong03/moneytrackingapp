// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/services/call_api.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  //สร้างตัวแปรช่องรหัสผ่าน
  bool pwdStatus = true;
  bool openpwd = true;
  //สร้างออปเจ็กต์ควบคุม TesxtFiled/TestFormField
  TextEditingController userFullnameCtrl = TextEditingController();
  TextEditingController userBirthDateCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController userPasswordCtrl = TextEditingController();

  //สร้างเมธอดแสดง WarningMessage
  showWarningMessage(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'คำเตือน',
          textAlign: TextAlign.center,
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'ตกลง',
            ),
          ),
        ],
      ),
    );
  }

  //สร้างเมธอดแสดง SuccessMessage
  showSuccessMessage(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ลงทะเบียนสำเร็จ',
          textAlign: TextAlign.center,
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'ตกลง',
            ),
          ),
        ],
      ),
    );
  }

  //ตัวแปรเก็บรูปที่มาจากการถ่ายรูปหรือรูปที่มาจากแกลอรี่
  File? _imageSelected;

  //ตัวแปรเก็บรูปที่เป็น base64
  String? _imageBase64Selected;

  //เมธอดเปิดกล้องเพื่อถ่ายรูป
  Future<void> _openCamera() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  //เมธอดเปิดแกลอรี่เพื่อเลือกรูป
  Future<void> _openGallery() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'ลงทะเบียน',
          style: TextStyle(
            color: Colors.brown,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.brown,
            size: 35,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg2.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Text(
                    'ข้อมูลผู้ใช้งาน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 70, 69, 69),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _imageBase64Selected == null
                                ? AssetImage('assets/images/user.png')
                                : FileImage(_imageSelected!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 100,
                          left: 50,
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      _openCamera().then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Open Camera...',
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 5.0,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      _openGallery().then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    leading: Icon(
                                      Icons.browse_gallery,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      'Open Gallery...',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: TextField(
                            controller: userFullnameCtrl,
                            decoration: InputDecoration(
                              labelText: 'ชื่อ-สกุล',
                              hintText: 'YOUR USERNAME',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(99, 95, 106, 105),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 180, 31, 31),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: TextField(
                            controller: userBirthDateCtrl,
                            decoration: InputDecoration(
                              labelText: 'วัน-เดือน-ปีเกิด',
                              hintText: 'YOUR BIRTHDAY',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: Icon(
                                FontAwesomeIcons.calendarDays,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(99, 95, 106, 105),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 180, 31, 31),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: TextField(
                            controller: userNameCtrl,
                            decoration: InputDecoration(
                              labelText: 'ชื่อผู้ใช้',
                              hintText: 'USERNAME',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(99, 95, 106, 105),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 180, 31, 31),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: TextField(
                            controller: userPasswordCtrl,
                            obscureText: openpwd,
                            decoration: InputDecoration(
                              labelText: 'รหัสผ่าน',
                              hintText: 'PASSWORD',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    pwdStatus = !pwdStatus;
                                    openpwd = !openpwd;
                                  });
                                },
                                icon: Icon(pwdStatus == true
                                    ? Icons.lock
                                    : Icons.lock_open),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(99, 95, 106, 105),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Colors.brown,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 180, 31, 31),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //validate UI
                            if (userFullnameCtrl.text.isEmpty ||
                                userBirthDateCtrl.text.isEmpty ||
                                userNameCtrl.text.isEmpty ||
                                userPasswordCtrl.text.isEmpty) {
                              showWarningMessage(
                                  context, 'กรุณากรอกข้อมูลให้ครบ');
                            } else if (_imageBase64Selected == null ||
                                _imageBase64Selected == '') {
                              showWarningMessage(
                                  context, 'กรุณาเลือกรูปภาพ หรือ ถ่ายรูปด้วย');
                            } else {
                              //พร้อมส่งข้อไปให้ API เพื่อบันทึกลง DB
                              //แพ็กข้อมูลส่งไปที่ API
                              User user = User(
                                userFullname: userFullnameCtrl.text,
                                userBirthDate: userBirthDateCtrl.text,
                                userName: userNameCtrl.text,
                                userPassword: userPasswordCtrl.text,
                                userImage: _imageBase64Selected,
                              );
                              //เรียกใช้เมธิด callAPI
                              CallApi.inserNewUserAPI(user).then((paramvalue) {
                                showSuccessMessage(
                                        context, 'บันทึกข้อมูลเรียบร้อย')
                                    .then((paramvalue) {
                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          child: Text(
                            'บันทึกการลงทะเบียน',
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.yellow[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.90,
                              MediaQuery.of(context).size.height * 0.08,
                            ),
                            shadowColor:
                                const Color.fromARGB(255, 131, 216, 216),
                            elevation: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
