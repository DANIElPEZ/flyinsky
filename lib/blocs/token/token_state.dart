class TokenState{
  TokenState({required this.tokenAccess,required this.isExpired});
  final String tokenAccess;
  final bool isExpired;

  factory TokenState.initial(){
    return TokenState(tokenAccess: '', isExpired: true);
  }

  TokenState copyWith({
    String? tokenAccess,
    bool? isExpired,
  }){
    return TokenState(
      tokenAccess: tokenAccess ?? this.tokenAccess,
      isExpired: isExpired ?? this.isExpired
    );
  }
}