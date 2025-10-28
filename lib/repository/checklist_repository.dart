import 'package:supabase_flutter/supabase_flutter.dart';

class CheckListRepository {
  Future<List<Map<String, dynamic>>> get_charts() async {
    try{
      final result = await Supabase.instance.client
          .from('checklist')
          .select()
          .order('name', ascending: true);
      return result;
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> filter_checklist(String query, List<Map<String, dynamic>> checklists) async {
    List<Map<String, dynamic>> filtered_checklists = [];
    for (int i = 0; i < checklists.length; i++) {
      if (checklists[i]['name'].toLowerCase().contains(
        query.toLowerCase(),
      )) {
        filtered_checklists.add(checklists[i]);
      }
    }
    return filtered_checklists;
  }
}
