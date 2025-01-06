class StatsCalculator {
  static double calculateBattingAverage(int hits, int atBats) {
    if (atBats == 0) return 0.0;
    return hits / atBats;
  }
  
  static double calculateERA(int earnedRuns, double innings) {
    if (innings == 0) return 0.0;
    return (earnedRuns * 9) / innings;
  }
  
  static double calculateOPS(double onBasePercentage, double sluggingPercentage) {
    return onBasePercentage + sluggingPercentage;
  }
  
  static double calculateSluggingPercentage(
    int singles,
    int doubles,
    int triples,
    int homeRuns,
    int atBats,
  ) {
    if (atBats == 0) return 0.0;
    return (singles + (2 * doubles) + (3 * triples) + (4 * homeRuns)) / atBats;
  }
}
