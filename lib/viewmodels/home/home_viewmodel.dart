import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mystats/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mystats/services/auth_service.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return HomeViewModel(authService);
});

class HomeState {
  final bool isLoading;
  final String? error;
  final UserModel? user;
  final DateTime selectedDate;
  final bool isPitcher;
  final List<dynamic> records;

  HomeState({
    this.isLoading = false,
    this.error,
    this.user,
    DateTime? selectedDate,
    this.isPitcher = true,
    this.records = const [],
  }) : selectedDate = selectedDate ?? DateTime.now();

  HomeState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
    DateTime? selectedDate,
    bool? isPitcher,
    List<dynamic>? records,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
      selectedDate: selectedDate ?? this.selectedDate,
      isPitcher: isPitcher ?? this.isPitcher,
      records: records ?? this.records,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final AuthService _authService;

  HomeViewModel(this._authService) : super(HomeState()) {
    _init();
  }

  Future<void> _init() async {
    state = HomeState();

    try {
      final token = await _authService.getToken();
      if (token == null) {
        state = state.copyWith(error: '로그인이 필요합니다.');
        return;
      }

      final isValid = await _authService.isLoggedIn();
      if (!isValid) {
        await _authService.logout();
        state = state.copyWith(error: '로그인이 필요합니다.');
        return;
      }

      await loadProfile();
      await loadRecords();
    } catch (e) {
      debugPrint('초기화 실패: $e');
      state = state.copyWith(error: '로그인이 필요합니다.');
    }
  }

  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      debugPrint('프로필 로딩 시작');
      final user = await _authService.apiService.getProfile();
      debugPrint('프로필 로딩 완료: ${user.name}');
      state = state.copyWith(user: user, isLoading: false, error: null);
    } catch (e) {
      debugPrint('프로필 로딩 실패: $e');
      if (e.toString().contains('401')) {
        await _authService.logout();
        state = state.copyWith(error: '로그인이 필요합니다.', isLoading: false);
      } else {
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }
  }

  Future<void> resetAndLoad() async {
    state = HomeState();
    await loadProfile();
    await loadRecords();
  }

  List<String> getAvailableYears() {
    if (state.records.isEmpty) {
      return ['${DateTime.now().year}년'];
    }

    final currentYear = DateTime.now().year;
    final years = state.records
        .map((record) => record.createdAt.year)
        .toSet()
        .toList()
      ..sort();
    if (!years.contains(currentYear)) {
      years.add(currentYear);
    }
    return years.map((year) => '$year년').toList();
  }

  Future<void> loadRecords() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      debugPrint(
          '기록 로딩 시작: ${state.selectedDate.year}년 ${state.selectedDate.month}월 ${state.isPitcher ? "투수" : "타자"}');
      final records = await _authService.apiService.getRecords(
        year: state.selectedDate.year,
        month: state.selectedDate.month,
        isPitcher: state.isPitcher,
      );
      debugPrint('기록 로딩 완료: ${records.length}개');
      state = state.copyWith(records: records, isLoading: false, error: null);
    } catch (e) {
      debugPrint('기록 로딩 실패: $e');
      if (e.toString().contains('401')) {
        await _authService.logout();
        state = state.copyWith(error: '로그인이 필요합니다.', isLoading: false);
      } else {
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }
  }

  void selectDate(DateTime date) {
    debugPrint('날짜 선택: ${date.year}년 ${date.month}월');
    state = state.copyWith(selectedDate: date);
    loadRecords();
  }

  void togglePlayerType() {
    debugPrint('선수 유형 전환: ${state.isPitcher ? "타자" : "투수"}');
    state = state.copyWith(isPitcher: !state.isPitcher);
    loadRecords();
  }
}
