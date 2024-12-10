// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miniproject_money_tracking/models/money.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/services/call_api.dart';
import 'package:miniproject_money_tracking/utils/env.dart';
import 'package:miniproject_money_tracking/views/money_in_and_out_and_total_ui.dart';
import 'package:miniproject_money_tracking/views/money_in_ui.dart';
import 'package:miniproject_money_tracking/views/money_out_ui.dart';

class HomeUi extends StatefulWidget {
  User? user;
  HomeUi({super.key, this.user});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  double _totalBalance = 0.0;
  double _totalExpense = 0.0;
  double _totalIncome = 0.0;

  bool _isLoading = true;
  Future<void> fetchMoneyList() async {
    try {
      List<Money> moneyList =
          await CallApi.calMoneybyUserIdAPI(widget.user!.userId!);
      setState(() {
        // คำนวณยอดเงินคงเหลือ, ยอดเงินออก, และยอดเงินเข้าในคราวเดียว
        _totalBalance = 0.0;
        _totalExpense = 0.0;
        _totalIncome = 0.0;

        for (var item in moneyList) {
          double amount = item.moneyInOut ?? 0.0;
          if (item.moneyType == 1) {
            _totalIncome += amount;
            _totalBalance += amount;
          } else if (item.moneyType == 2) {
            _totalExpense += amount;
            _totalBalance -= amount;
          }
        }

        _isLoading = false; // เปลี่ยนสถานะการโหลด
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // เปลี่ยนสถานะการโหลดในกรณีเกิดข้อผิดพลาด
      });
      print("Error fetching money list: $e");
    }
  }

  int _currentIndex = 1;
  late List _currentShow = [
    MoneyInUi(user: widget.user),
    MoneyInAndOutAndTotalUi(user: widget.user),
    MoneyOutUi(user: widget.user),
  ];

  @override
  void initState() {
    super.initState();
    fetchMoneyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Transform.rotate(
                  angle: 3.14159,
                  child: Icon(
                    FontAwesomeIcons.moneyBillTrendUp,
                    size: 30,
                  ),
                )
              ],
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 70,
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(
                  FontAwesomeIcons.moneyBillTrendUp,
                  size: 30,
                ),
              ],
            ),
            label: ' ',
          ),
        ],
        backgroundColor: Colors.yellow[500],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: BottomCurveClipper(),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            color: Colors.yellow[500],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                      ),
                                      Text(
                                        widget.user?.userFullname ??
                                            "Unknown User",
                                        style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                      ),
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            widget.user!.userImage == null
                                                ? AssetImage(
                                                    'assets/images/user.png')
                                                : NetworkImage(
                                                    '${Env.baseUrl}/moneytrackingservice/uploading/user/${widget.user!.userImage!}',
                                                  ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.20,
                      left: MediaQuery.of(context).size.width * 0.08,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(4, 4),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                            left: 15,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'ยอดเงินคงเหลือ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _totalBalance.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      fetchMoneyList();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.rotate_left_rounded,
                                    color: Colors.white,
                                  ),
                                  iconSize:
                                      MediaQuery.of(context).size.height *
                                          0.03,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 25,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'ยอดเงินเข้ารวม',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        _totalIncome.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Icon(
                                      Icons.download,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 25,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'ยอดเงินออกรวม',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        _totalExpense.toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _currentShow[_currentIndex],
                ),
              ],
            ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
