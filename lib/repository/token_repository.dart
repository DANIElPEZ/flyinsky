import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flyinsky/sqlite/sql_helper.dart';

class TokenRepository {
  String authVatsim() {
    final String authUrl = dotenv.env['AUTH'] ?? '';
    final String clientId = dotenv.env['CLIENT_ID'] ?? '';
    final String scopes = dotenv.env['SCOPES'] ?? '';
    final String redirectUri = dotenv.env['REDIRECT_URL'] ?? '';

    return "$authUrl?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=${Uri.encodeComponent(scopes)}";
  }

  Future<Map<String,dynamic>> getAccessToken(String code) async {
    final String tokenUrl = dotenv.env['ACCESS_TOKEN'] ?? '';
    final String clientId = dotenv.env['CLIENT_ID'] ?? '';
    final String clientSecret = dotenv.env['CLIENT_SECRET'] ?? '';
    final String redirectUri = dotenv.env['REDIRECT_URL'] ?? '';

    try {
      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access_token'];
        final expiresIn = data['expires_in'];
        final DateTime now = DateTime.now();
        final DateTime expirationDate = now.add(Duration(seconds: expiresIn));
        final day = expirationDate.day;
        final month = expirationDate.month;
        final year = expirationDate.year;
        return {'token': accessToken, 'day': day, 'month': month, 'year': year};
      }
    } catch (e) {
      print(e);
    }
    return {};
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
