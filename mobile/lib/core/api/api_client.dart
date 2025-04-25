import 'dart:developer' as Logger;

import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://172.20.10.3:8080',
      baseUrl: 'https://reqres.in/api/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      Logger.log('Erreur GET ($path): $e');
      rethrow;
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      Logger.log('Erreur POST ($path): $e');
      rethrow;
    }
  }
}
