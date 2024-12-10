import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miniproject_money_tracking/models/money.dart';
import 'package:miniproject_money_tracking/models/user.dart';
import 'package:miniproject_money_tracking/utils/env.dart';

class CallApi {
  //เรียก api เพื่อเข้าถึงข้อมูล
  static Future<List<User>> checkLoginAPI(User user) async {
    //คำสั่งเรียกใช้งาน API ทั้งนี้พร้อมกับกำหนดตัวแปรเพื่อรับค่าที่ส่งกลับมา
    final  responseData = await http.post(
      Uri.parse('${Env.baseUrl}/moneytrackingservice/apis/check_login_api.php'),
      body: jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
     //เอาค่าที่ส่งกลับมาแปลงจาก JSON เพื่อเอาไปใช้ในแอปฯ
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<User> data = await responseDataDecode.map<User>((json) => User.fromJson(json)).toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... Eiei');
    }
  }

  //เรียก api เพื่อส่งข้อมูล user ไปบันทึกข้อมูลในฐานข้อมูล
  static Future<List<User>> inserNewUserAPI(User user) async {
    //เรียก API ที่ server 
    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/moneytrackingservice/apis/insert_new_user_api.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    //ส่งผลการทำงานที่ได้จาดการเรียกใช้ API ที่ sercer กลับไปยังจุดเรียกใช้เมธอด
    if (responseData.statusCode == 200) {
      final data = await json.decode(responseData.body).map<User>((e) => User.fromJson(e)).toList();
      return data;
    } else {
      throw Exception('Failed to insert data');
    }
  }

  //เรียกดูข้อมูลการเงินทั้งหมด
  static Future<List<Money>> calMoneybyUserIdAPI(String userId) async {
    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/moneytrackingservice/apis/cal_money_by_userid_api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
 
    //เอาค่าที่ส่งกลับมาแปลงจาก JSON เพื่อเอาไปใช้ในแอปฯ
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<Money> data = await responseDataDecode.map<Money>((json) => Money.fromJson(json)).toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... Eiei');
    }
  }

   static Future<List<Money>> insertMoneyInOutAPI(Money money) async {
    final responseData = await http.post(
      Uri.parse("${Env.baseUrl}/moneytrackingservice/apis/insert_money_in_out_api.php"),
      body: jsonEncode(money.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<Money> data = await responseDataDecode
          .map<Money>((json) => Money.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... Eiei');
    }
  }
}
  
