import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flyinsky/sqlite/sql_helper.dart';

class AuthRepository {
  final client = Supabase.instance.client;

  Future<void> signUp(String username, String password) async {
    final db=DatabaseHelper();
    final hashedPassword=BCrypt.hashpw(password, BCrypt.gensalt());
    final existsResult=await client.from('purchases').select().eq('username', username).maybeSingle();
    if(existsResult!.isNotEmpty) return;
    final result=await client.from('purchases').insert({'username':username, 'password':hashedPassword}).select().maybeSingle();
    db.loginOrSignIn(result?['user_id'], result?['has_purchased'], result?['username']);
  }

  Future<void> signIn(String username, String password) async {
    final db=DatabaseHelper();
    final result=await client.from('purchases').select().eq('username', username).maybeSingle();
    final valid=BCrypt.checkpw(password, result?['password']);
    if (valid) db.loginOrSignIn(result?['user_id'], result?['has_purchased'], result?['username']);
  }

  Future<Map<String, dynamic>> getUser()async{
    final db=DatabaseHelper();
    final result=db.getAuth();
    return result;
  }

  Future<void> logOut()async{
    final db=DatabaseHelper();
    db.logOut();
  }
}
