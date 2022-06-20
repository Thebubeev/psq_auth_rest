import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psq/entities/sms_entity.dart';
import 'package:psq/entities/user_entity.dart';
import 'package:http/http.dart' as http;
import 'package:psq/entities/verify_sms_entity.dart';

class InternetStorageApi {
  final String BASE_URL = "http://82.148.19.59:27015/api/";

  Future<SmsEntity> validatePhone(String phone) async {
    final response = await http.post(
      Uri.parse("${BASE_URL}validatePhone"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'phone': phone,
        },
      ),
    );
    return SmsEntity.fromJson(jsonDecode(response.body));
  }

  Future<VerifySmsEntity> verify(String phone, int code) async {
    final response = await http.post(
      Uri.parse("${BASE_URL}verify"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{'phone': phone, 'code': code},
      ),
    );
    return VerifySmsEntity.fromJson(jsonDecode(response.body));
  }

  Future<UserInfoEntity> register(String phone, String name, int code) async {
    final response = await http.post(
      Uri.parse("${BASE_URL}register"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, Object>{'phone': phone, 'name': name, 'code': code},
      ),
    );

    return UserInfoEntity.fromJson(jsonDecode(response.body));
  }
}
