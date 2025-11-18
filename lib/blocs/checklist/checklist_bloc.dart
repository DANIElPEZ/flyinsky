import 'package:flyinsky/blocs/checklist/checklist_state.dart';
import 'package:flyinsky/blocs/checklist/checklist_event.dart';
import 'package:flyinsky/repository/checklist_repository.dart';
import 'package:bloc/bloc.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final CheckListRepository checklistrepository;

  ChecklistBloc({required this.checklistrepository})
    : super(ChecklistState.initial()) {
    on<loadChecklists>((event, emit) async {
      try {
        emit(state.copyWith(loading: true));
        final checklists = await checklistrepository.get_charts();
        emit(state.copyWith(checklists: checklists, filtered_checklists: checklists, loading: false));
      } catch (e) {
        print(e);
      }
      emit(state.copyWith(loading: false));
    });
    on<filteredChecklist>((event, emit) async {
      emit(state.copyWith( filter_by_name: event.query));
      final filtered_checklists = await checklistrepository.filter_checklist(
        state. filter_by_name,
        state.checklists
      );
      emit(state.copyWith(filtered_checklists: filtered_checklists));
    });
  }
}
