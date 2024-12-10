// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:miniproject_money_tracking/views/login_ui.dart';
import 'package:miniproject_money_tracking/views/register_ui.dart';

class StartAppUi extends StatefulWidget {
  const StartAppUi({super.key});

  @override
  State<StartAppUi> createState() => _StartAppUiState();
}

class _StartAppUiState extends State<StartAppUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                ),
                Image(
                  image: AssetImage('assets/images/money.png'),
                  height: 450,
                ),
                Container(
                  width: 150,
                  child: Divider(
                    color: const Color.fromARGB(255, 219, 218, 218),
                    thickness: 2,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'บันทึก\nรายรับรายจ่าย',
                  style: TextStyle(
                    color: Colors.brown[500],
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginUi()));
                  },
                  child: Text(
                    'เริ่มต้นใช้งานแอปพลิเคชัน',
                    style: TextStyle(
                      color: Colors.brown[500],
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.90,
                      MediaQuery.of(context).size.height * 0.08,
                    ),
                    shadowColor: const Color.fromARGB(255, 131, 216, 216),
                    elevation: 15,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ยังไม่ได้ลงทะเบียน?  ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                      ),
                    ),
                    InkWell(
                      //หรือใช้ GestureDetector() ก็ได้
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUI()));
                      },
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                          color: Colors.brown[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
