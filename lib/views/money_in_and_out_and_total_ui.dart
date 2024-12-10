import 'package:flutter/material.dart';
import 'package:miniproject_money_tracking/models/money.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/services/call_api.dart';

class MoneyInAndOutAndTotalUi extends StatefulWidget {
  User? user;

  MoneyInAndOutAndTotalUi({
    this.user,
    super.key,
  });

  @override
  State<MoneyInAndOutAndTotalUi> createState() =>
      _MoneyInAndOutAndTotalUiState();
}

class _MoneyInAndOutAndTotalUiState extends State<MoneyInAndOutAndTotalUi> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Money> _moneyList = [];

  @override
  void initState() {
    fetchMoneyList();
    super.initState();
  }

  Future<void> fetchMoneyList() async {
    try {
      List<Money> moneyList =
          await CallApi.calMoneybyUserIdAPI(widget.user!.userId!);
      setState(() {
        _moneyList = moneyList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error fetching data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : _moneyList.isEmpty
                  ? Center(
                      child: Text(
                        'ไม่มีข้อมูลการเงิน',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                      ),
                      children: [
                        Center(
                          child: Text(
                            "เงินเข้า/เงินออก",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ..._moneyList.map((money) {
                          return Column(
                            children: [
                              Divider(),
                              ListTile(
                                title: Text(money.moneyDetail ?? "ไม่มีข้อมูล"),
                                subtitle:
                                    Text(money.moneyDate ?? "ไม่ระบุวันที่"),
                                trailing: Text(
                                  "${(money.moneyInOut ?? 0.0).toStringAsFixed(2)} บาท",
                                  style: TextStyle(
                                    color: money.moneyType == 1
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                leading: Icon(
                                  money.moneyType == 1
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: money.moneyType == 1
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
    );
  }
}
