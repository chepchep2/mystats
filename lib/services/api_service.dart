import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/record/batter_record_model.dart';
import 'package:mystats/models/record/pitcher_record_model.dart';
import 'package:mystats/models/user/user_model.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // Android용 localhost
      baseUrl: 'http://10.0.2.2:8080',
      contentType: 'application/json',
    ),
  );

  // 토큰을 헤더에 추가
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    debugPrint('Token set: Bearer $token');
  }

  void removeToken() {
    _dio.options.headers.remove('Authorization');
    debugPrint('Token removed');
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

  // 회원가입
  Future<(String, UserModel)> register({
    required String email,
    required String password,
    required String name,
    String? team,
  }) async {
    try {
      debugPrint('회원가입 시도: $email');
      final data = {
        'email': email,
        'password': password,
        'name': name,
      };

      if (team != null) {
        data['team'] = team;
      }

      final response = await _dio.post('/auth/signup', data: data);

      debugPrint('회원가입 응답: ${response.data}');

      final token = response.data['token'] as String;
      final user = UserModel.fromJson(response.data['user']);

      return (token, user);
    } on DioException catch (e) {
      debugPrint('회원가입 에러 응답: ${e.response?.data}');
      if (e.response != null && e.response?.statusCode != 200) {
        throw e.response?.data?['error'] ?? '회원가입에 실패했습니다.';
      }
      throw '서버 연결에 실패했습니다.';
    }
  }

  // 프로필 조회
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get('/api/profile');
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      debugPrint('프로필 조회 실패: ${e.message}');
      throw e.response?.data?['error'] ?? '프로필 조회에 실패했습니다.';
    }
  }

  // 기록 조회
  Future<List<dynamic>> getRecords({
    required int year,
    required int month,
    required bool isPitcher,
  }) async {
    try {
      final response = await _dio.get(
        '/api/records',
        queryParameters: {
          'year': year,
          'month': month,
          'type': isPitcher ? 'pitcher' : 'batter',
        },
      );

      debugPrint('기록 조회 응답: ${response.data}');

      if (response.data == null) {
        debugPrint('응답 데이터가 null입니다.');
        return [];
      }

      if (response.data['records'] == null) {
        debugPrint('records가 null입니다.');
        return [];
      }

      debugPrint('records 타입: ${response.data['records'].runtimeType}');

      final records = response.data['records'] as List<dynamic>?;
      if (records == null) return [];

      if (isPitcher) {
        return records.map((record) {
          debugPrint('pitcher record: $record');
          return PitcherRecordModel.fromJson(record as Map<String, dynamic>);
        }).toList();
      } else {
        return records.map((record) {
          debugPrint('batter record: $record');
          return BatterRecordModel.fromJson(record as Map<String, dynamic>);
        }).toList();
      }
    } on DioException catch (e) {
      debugPrint('기록 조회 실패: ${e.message}');
      debugPrint('에러 응답: ${e.response?.data}');
      throw e.response?.data?['error'] ?? '기록 조회에 실패했습니다.';
    } catch (e) {
      debugPrint('예상치 못한 에러: $e');
      rethrow;
    }
  }

  // 타자 기록 생성
  Future<BatterRecordModel> createBatterRecord({
    required DateTime date,
    String? opponent,
    String? location,
    String? result,
    int? myScore,
    int? opponentScore,
    required int plateAppearances,
    required int atBats,
    required int runs,
    required int hits,
    required int singles,
    required int doubles,
    required int triples,
    required int homeruns,
    required int walks,
    required int rbis,
    required int steals,
    required int hitByPitch,
    required int strikeouts,
    required int doublePlays,
  }) async {
    try {
      final response = await _dio.post('/api/records/batter', data: {
        'game': {
          'date': date.toIso8601String().split('T')[0],
          'opponent': opponent,
          'location': location,
          'result': result,
          'my_score': myScore,
          'opponent_score': opponentScore,
        },
        'plate_appearances': plateAppearances,
        'at_bats': atBats,
        'runs': runs,
        'hits': hits,
        'singles': singles,
        'doubles': doubles,
        'triples': triples,
        'homeruns': homeruns,
        'walks': walks,
        'rbis': rbis,
        'steals': steals,
        'hit_by_pitch': hitByPitch,
        'strikeouts': strikeouts,
        'double_plays': doublePlays,
      });

      debugPrint('타자 기록 생성 응답: ${response.data}');
      return BatterRecordModel.fromJson(response.data['record']);
    } on DioException catch (e) {
      debugPrint('타자 기록 생성 실패: ${e.message}');
      throw e.response?.data?['error'] ?? '타자 기록 생성에 실패했습니다.';
    }
  }

  // 투수 기록 생성
  Future<PitcherRecordModel> createPitcherRecord({
    required DateTime date,
    String? opponent,
    String? location,
    String? result,
    int? myScore,
    int? opponentScore,
    required double innings,
    required int wins,
    required int losses,
    required int saves,
    required int holds,
    required int battersFaced,
    required int opponentAtBats,
    required int hitsAllowed,
    required int homerunsAllowed,
    required int walks,
    required int hitByPitch,
    required int strikeouts,
    required int earnedRuns,
  }) async {
    try {
      final response = await _dio.post('/api/records/pitcher', data: {
        'game': {
          'date': date.toIso8601String().split('T')[0],
          'opponent': opponent,
          'location': location,
          'result': result,
          'my_score': myScore,
          'opponent_score': opponentScore,
        },
        'innings': innings,
        'wins': wins,
        'losses': losses,
        'saves': saves,
        'holds': holds,
        'batters_faced': battersFaced,
        'opponent_at_bats': opponentAtBats,
        'hits_allowed': hitsAllowed,
        'homeruns_allowed': homerunsAllowed,
        'walks': walks,
        'hit_by_pitch': hitByPitch,
        'strikeouts': strikeouts,
        'earned_runs': earnedRuns,
      });

      debugPrint('투수 기록 생성 응답: ${response.data}');
      return PitcherRecordModel.fromJson(response.data['record']);
    } on DioException catch (e) {
      debugPrint('투수 기록 생성 실패: ${e.message}');
      throw e.response?.data?['error'] ?? '투수 기록 생성에 실패했습니다.';
    }
  }
}
