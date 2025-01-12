import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mystats/services/api_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _api = ApiService();

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      // 토큰 유효성 검증
      return await _api.validateToken();
    } catch (e) {
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
    _api.setToken(token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    _api.removeToken();
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'authToken');
    if (token != null) {
      _api.setToken(token);
    }
    return token;
  }
}
