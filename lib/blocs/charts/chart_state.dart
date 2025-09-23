class chartsState {
  final String icao;
  final String token;
  final Map<String, List<Map<String, String>>> charts;
  final String? urlChart;

  chartsState({required this.charts, this.urlChart, required this.icao, required this.token});

  factory chartsState.initial() {
    return chartsState(icao:'',charts: {}, urlChart: '', token: '');
  }

  chartsState copyWith({Map<String, List<Map<String, String>>>? charts, String? urlChart, String? icao, String? token}) {
    return chartsState(
      charts: charts ?? this.charts,
      urlChart: urlChart ?? this.urlChart,
      icao:  icao ?? this.icao,
      token: token ?? this.token
    );
  }
}
