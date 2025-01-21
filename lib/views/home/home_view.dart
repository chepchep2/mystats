import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mystats/services/auth_service.dart';
import 'package:mystats/viewmodels/home/home_viewmodel.dart';
import 'package:mystats/viewmodels/auth/login_viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeVM = ref.read(homeViewModelProvider.notifier);

    if (homeState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final years = homeVM.getAvailableYears();

    final List<String> months = List.generate(12, (i) => '${i + 1}월');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: homeState.isLoading
                ? null
                : () {
                    context.push('/record/add');
                  },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: homeState.isLoading
                ? null
                : () async {
                    await ref.read(authServiceProvider).logout();
                    if (context.mounted) {
                      ref.read(loginViewModelProvider.notifier).clearFields();
                      context.go('/login');
                    }
                  },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '프로필',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                homeState.user?.name ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                homeState.user?.email ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                homeState.user?.team ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '연도 선택',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        items: years
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: '${homeState.selectedDate.year}년',
                        onChanged: (value) {
                          if (value != null) {
                            final year = int.parse(value.replaceAll('년', ''));
                            homeVM.selectDate(
                                DateTime(year, homeState.selectedDate.month));
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: 140,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '월 선택',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        items: months
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: '${homeState.selectedDate.month}월',
                        onChanged: (value) {
                          if (value != null) {
                            final month = int.parse(value.replaceAll('월', ''));
                            homeVM.selectDate(
                                DateTime(homeState.selectedDate.year, month));
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: 140,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 280,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => homeVM.togglePlayerType(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: homeState.isPitcher
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '투수',
                                    style: TextStyle(
                                      color: homeState.isPitcher
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => homeVM.togglePlayerType(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !homeState.isPitcher
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '타자',
                                    style: TextStyle(
                                      color: !homeState.isPitcher
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (homeState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (homeState.error != null)
                  Center(
                    child: Text(
                      homeState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (homeState.records.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text(
                        '기록이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeState.isPitcher ? '투수 성적' : '타자 성적',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (homeState.isPitcher)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '경기수',
                                            homeState.records.first.games
                                                .toString()),
                                        _buildStatItem(
                                            '방어율',
                                            (homeState.records.first.era ??
                                                    0.00)
                                                .toStringAsFixed(2)),
                                        _buildStatItem(
                                            '승',
                                            homeState.records.first.wins
                                                .toString()),
                                        _buildStatItem(
                                            '패',
                                            (homeState.records.first.losses ??
                                                    0)
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '세이브',
                                            (homeState.records.first.saves ?? 0)
                                                .toString()),
                                        _buildStatItem(
                                            '홀드',
                                            (homeState.records.first.holds ?? 0)
                                                .toString()),
                                        _buildStatItem(
                                            '승률',
                                            (homeState.records.first
                                                        .winningPct ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            '이닝',
                                            homeState.records.first.innings
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '상대타자',
                                            (homeState.records.first
                                                        .battersFaced ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '상대타수',
                                            (homeState.records.first
                                                        .opponentAtBats ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '피안타',
                                            homeState.records.first.hitsAllowed
                                                .toString()),
                                        _buildStatItem(
                                            '피홈런',
                                            (homeState.records.first
                                                        .homerunsAllowed ??
                                                    0)
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '볼넷',
                                            (homeState.records.first.walks ?? 0)
                                                .toString()),
                                        _buildStatItem(
                                            '사구',
                                            (homeState.records.first
                                                        .hitByPitch ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '탈삼진',
                                            homeState.records.first.strikeouts
                                                .toString()),
                                        _buildStatItem(
                                            '실점',
                                            homeState.records.first.earnedRuns
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            'WHIP',
                                            (homeState.records.first.whip ??
                                                    0.00)
                                                .toStringAsFixed(2)),
                                        _buildStatItem(
                                            '피안타율',
                                            (homeState.records.first
                                                        .opponentAvg ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            '탈삼진율',
                                            (homeState.records.first
                                                        .strikeoutRate ??
                                                    0.00)
                                                .toStringAsFixed(2)),
                                        const SizedBox(width: 80),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '경기수',
                                            homeState.records.first.games
                                                .toString()),
                                        _buildStatItem(
                                            '타율',
                                            (homeState.records.first.avg ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            '타석',
                                            homeState
                                                .records.first.plateAppearances
                                                .toString()),
                                        _buildStatItem(
                                            '타수',
                                            homeState.records.first.atBats
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '득점',
                                            homeState.records.first.runs
                                                .toString()),
                                        _buildStatItem(
                                            '안타',
                                            homeState.records.first.hits
                                                .toString()),
                                        _buildStatItem(
                                            '2루타',
                                            (homeState.records.first.doubles ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '3루타',
                                            (homeState.records.first.triples ??
                                                    0)
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '홈런',
                                            homeState.records.first.homeruns
                                                .toString()),
                                        _buildStatItem(
                                            '타점',
                                            homeState.records.first.rbis
                                                .toString()),
                                        _buildStatItem(
                                            '도루',
                                            (homeState.records.first.steals ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '볼넷',
                                            (homeState.records.first.walks ?? 0)
                                                .toString()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '사구',
                                            (homeState.records.first
                                                        .hitByPitch ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '삼진',
                                            (homeState.records.first
                                                        .strikeouts ??
                                                    0)
                                                .toString()),
                                        _buildStatItem(
                                            '병살타',
                                            (homeState.records.first
                                                        .doublePlays ??
                                                    0)
                                                .toString()),
                                        const SizedBox(width: 80),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildStatItem(
                                            '장타율',
                                            (homeState.records.first.slg ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            '출루율',
                                            (homeState.records.first.obp ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            'OPS',
                                            (homeState.records.first.ops ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                        _buildStatItem(
                                            'BB/K',
                                            (homeState.records.first.bbK ??
                                                    0.000)
                                                .toStringAsFixed(3)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
