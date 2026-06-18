abstract class TokenEvent{}

class getToken extends TokenEvent{}

class saveToken extends TokenEvent{
  final Map<String, dynamic> token;
  saveToken(this.token);
}

class checkToken extends TokenEvent{}