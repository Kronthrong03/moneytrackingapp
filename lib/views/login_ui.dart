// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/services/call_api.dart';
import 'package:miniproject_money_tracking/views/home_ui.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  //สร้างตัวแปรช่องรหัสผ่าน
  bool pwdStatus = true;
  bool openpwd = true;
  //สร้สงตัวแปรควบคุม TesctField (อย่าลืมไปผูกกับ TextFiled)
  TextEditingController userNameCtrl = TextEditingController(text: '');
  TextEditingController userPasswordCtrl = TextEditingController(text: '');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'เข้าใช้งาน Money Tracking',
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
                  SizedBox(height: 90),
                  Image.asset(
                    'assets/images/money.png',
                    height: 250,
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
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
                            //validate หน้าจอ
                            if (userNameCtrl.text.trim().length == 0) {
                              showWarningMessage(
                                  context, 'ป้อนชื่อผู้ใช้ด้วย...');
                            } else if (userPasswordCtrl.text.trim().length ==
                                0) {
                              showWarningMessage(
                                  context, 'ป้อนรหัสผ่านด้วย...');
                            } else {
                              //ส่งข้อมูลที่ป้อนในที่นี้คือ ชื่อผู้ใช้ รหัสผ่าน ไปที่ API
                              //แล้วทำงานต่อไป
                              User user = User(
                                userName: userNameCtrl.text.trim(),
                                userPassword: userPasswordCtrl.text.trim(),
                              );
                              //
                              CallApi.checkLoginAPI(user).then((value) => {
                                    if (value[0].message == "1")
                                      {
                                        //เปิดไปหน้า home_ui
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomeUi(user: value[0]),
                                          ),
                                        ),
                                      }
                                    else
                                      {
                                        //แสดง MSG ชื่อผ฿้ใช้รหัสผ่านไม่ถ฿กต้อง
                                        showWarningMessage(context,
                                            'ชื่อผู้ใช้รหัสผ่านไม่ถูกต้อง')
                                      }
                                  });
                            }
                          },
                          child: Text(
                            'เข้าใข้งาน',
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
