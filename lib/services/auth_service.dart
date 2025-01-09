import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: 'authToken');
      return token != null;
    } catch (e) {
      return false;
    }
  }

  // TODO: saveToken 메서드 구현(로그인 성공시 토큰 저장)
  // TODO: logout 메서드 구현(토큰 삭제)
}
