
class Money {
  String? message;
  String? moneyId;
  String? moneyDetail;
  String? moneyDate;
  double? moneyInOut;
  int? moneyType;
  String? userId;

  Money(
      {this.message,
      this.moneyId,
      this.moneyDetail,
      this.moneyDate,
      this.moneyInOut,
      this.moneyType,
      this.userId});

  Money.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    moneyId = json['moneyId'];
    moneyDetail = json['moneyDetail'];
    moneyDate = json['moneyDate'];
    moneyInOut = json['moneyInOut'] != null
        ? double.tryParse(json['moneyInOut'].toString())
        : null;
    moneyType = json['moneyType'] != null
        ? int.tryParse(json['moneyType'].toString())
        : null;
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['moneyId'] = this.moneyId;
    data['moneyDetail'] = this.moneyDetail;
    data['moneyDate'] = this.moneyDate;
    data['moneyInOut'] = this.moneyInOut;
    data['moneyType'] = this.moneyType;
    data['userId'] = this.userId;
    return data;
  }
}
