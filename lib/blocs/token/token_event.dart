abstract class TokenEvent{}

class getToken extends TokenEvent{}

class saveToken extends TokenEvent{
  final String code;
  saveToken(this.code);
}

class checkToken extends TokenEvent{}