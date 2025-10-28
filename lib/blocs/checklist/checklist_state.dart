class ChecklistState {
  final String filter_by_name;
  final List<Map<String, dynamic>> checklists;
  final List<Map<String, dynamic>> filtered_checklists;

  ChecklistState({
    required this.filter_by_name,
    required this.checklists,
    required this.filtered_checklists,
  });

  factory ChecklistState.initial() {
    return ChecklistState(
      filter_by_name: '',
      checklists: [],
      filtered_checklists: [],
    );
  }

  ChecklistState copyWith({
    String? filter_by_name,
    List<Map<String, dynamic>>? checklists,
    List<Map<String, dynamic>>? filtered_checklists,
  }) {
    return ChecklistState(
      filter_by_name: filter_by_name ?? this.filter_by_name,
      checklists: checklists ?? this.checklists,
      filtered_checklists: filtered_checklists ?? this.filtered_checklists,
    );
  }
}
