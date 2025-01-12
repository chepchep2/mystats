import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mystats/models/user/user_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // Android 에뮬레이터용 localhost
      baseUrl: 'http://10.0.2.2:8080',
      contentType: 'application/json',
    ),
  );

  // 토큰을 헤더에 추가
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<(String, UserModel)> login(String email, String password) async {
    try {
      debugPrint('로그인 시도: $email');
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      debugPrint(
        '로그인 응답: ${response.data}',
      );
      return (
        response.data['token'] as String,
        UserModel.fromJson(response.data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      debugPrint(
        'DioError: ${e.message}',
      );
      debugPrint(
        'Error Response: ${e.response?.data}',
      );
      if (e.response != null && e.response?.statusCode != 200) {
        throw '이메일 또는 비밀번호가 잘못되었습니다.';
      }
      throw e.response?.data?['error'] ?? '로그인에 실패했습니다.';
    }
  }

  // 토큰 유효성 검증
  Future<bool> validateToken() async {
    try {
      await _dio.get('/auth/validate');
      return true;
    } on DioException catch (e) {
      debugPrint('Token validation failed: ${e.message}');
      return false;
    }
  }
}
