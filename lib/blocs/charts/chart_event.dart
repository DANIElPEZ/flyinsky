abstract class chartsEvent {}

class setIcao extends chartsEvent{
  final String icao;
  setIcao(this.icao);
}

class loadCharts extends chartsEvent{}

class loadPdfChart extends chartsEvent{
  final String idChart;
  loadPdfChart(this.idChart);
}

class loadToken extends chartsEvent{}