import 'dart:developer' as Logger;
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://172.20.10.3:8080',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Response> get(String path, {String? token}) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      Logger.log('Erreur GET ($path): $e');
      rethrow;
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data, {String? token}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      Logger.log('Erreur POST ($path): $e');
      rethrow;
    }
  }

  Future<Response> patch(String path, Map<String, dynamic> data, {String? token}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      Logger.log('Erreur PATCH ($path): $e');
      rethrow;
    }
  }

  Future<Response> delete(String path, {String? token}) async {
    try {
      return await _dio.delete(
        path,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
    } catch (e) {
      Logger.log('Erreur DELETE ($path): $e');
      rethrow;
    }
  }


}
