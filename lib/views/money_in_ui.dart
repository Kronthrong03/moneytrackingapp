// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:miniproject_money_tracking/models/money.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/services/call_api.dart';

class MoneyInUi extends StatefulWidget {
  User? user;
  MoneyInUi({super.key, this.user});

  @override
  State<MoneyInUi> createState() => _MoneyInUiState();
}

class _MoneyInUiState extends State<MoneyInUi> {
  TextEditingController moneyDetailController = TextEditingController(text: "");
  TextEditingController moneyInOutController = TextEditingController(text: "");
  TextEditingController moneyDateMonthYearController =
      TextEditingController(text: "");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text('เงินเข้า',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    controller: moneyDetailController,
                    decoration: InputDecoration(
                      labelText: 'รายการสินค้าเข้า',
                      hintText: 'Detail',
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
                          color: Colors.brown,
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
                    controller: moneyInOutController,
                    decoration: InputDecoration(
                      labelText: 'จำนวนเงินเข้า',
                      hintText: '0.00',
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
                          color: Colors.brown,
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
                    controller: moneyDateMonthYearController,
                    decoration: InputDecoration(
                      labelText: 'วัน เดือน ปีที่เงินเข้า',
                      hintText: 'DATE INCOME',
                      suffixIcon: Icon(
                        Icons.calendar_month,
                      ),
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
                          color: Colors.brown,
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
                ElevatedButton(
                  onPressed: () {
                    if (moneyDetailController.text.isEmpty ||
                        moneyInOutController.text.isEmpty ||
                        moneyDateMonthYearController.text.isEmpty) {
                      showWarningMessage(context, 'กรุณากรอกข้อมูลให้ครบ');
                    } else {
                      Money money = Money(
                        moneyDetail: moneyDetailController.text,
                        moneyInOut: double.parse(moneyInOutController.text),
                        moneyDate: moneyDateMonthYearController.text,
                        userId: widget.user!.userId,
                        moneyType: 1,
                      );
                      CallApi.insertMoneyInOutAPI(money).then((value) => {
                            if (value[0].message == "1")
                              {
                                showSuccessMessage(
                                    context, 'บันทึกข้อมูลเรียบร้อย')
                              }
                            else
                              {
                                //แสดง MSG ชื่อผ฿้ใช้รหัสผ่านไม่ถ฿กต้อง
                                showWarningMessage(
                                    context, 'ชื่อผู้ใช้รหัสผ่านไม่ถูกต้อง')
                              }
                          });
                    }
                  },
                  child: Text(
                    'บันทึกเงินเข้า',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
