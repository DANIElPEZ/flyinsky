import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flyinsky/sqlite/sql_helper.dart';

class TokenRepository {
  Future<String> authVatsim() async{
    String webBridge = dotenv.env['WEB_BRIDGE'] ?? '';
    return webBridge;
  }

  Future<String> getToken()async{
    final token=await DatabaseHelper().getToken();
    return token['token'];
  }

  Future<void> saveToken(Map<String, dynamic> token)async {
    final db=DatabaseHelper();
    final accessToken=token['token'];
    final day=token['day'];
    final month=token['month'];
    final year=token['year'];
    await db.saveToken(accessToken, day, month, year);
  }

  Future<bool> isTokenExpired()async{
    final db=DatabaseHelper();
    return await db.isTokenExpired();
  }
}
