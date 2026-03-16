import 'dart:async';
import 'package:flyinsky/blocs/charts/chart_state.dart';
import 'package:flyinsky/blocs/charts/chart_event.dart';
import 'package:flyinsky/repository/charts_repository.dart';
import 'package:flyinsky/blocs/token/token_bloc.dart';
import 'package:bloc/bloc.dart';

class chartsBloc extends Bloc<chartsEvent, chartsState>{
  final ChartsRepository chartsrepository;
  late final StreamSubscription tokenSubscription;

  chartsBloc({required this.chartsrepository}):super(chartsState.initial()){
    on<setIcao>((event, emit){
      emit(state.copyWith(icao: event.icao, loading: true));
    });
    on<loadCharts>((event, emit)async{
      try {
        final charts = await chartsrepository.getGroupedCharts(state.token, state.icao);
        emit(state.copyWith(charts: charts));
      }catch(e){
        print(e);
      }
      emit(state.copyWith(loading: false));
    });
    on<loadPdfChart>((event, emit)async{
      try{
        final url=await chartsrepository.getChart(state.token, event.idChart);
        emit(state.copyWith(urlChart: url));
      }catch(e){
        print(e);
      }
    });
    on<loadToken>((event, emit)async{
      try {
        final token = await chartsrepository.getToken();
        emit(state.copyWith(token: token));
      }catch(e){
        print(e);
      }
    });
  }

  @override
  Future<void> close() {
    tokenSubscription.cancel();
    return super.close();
  }
}