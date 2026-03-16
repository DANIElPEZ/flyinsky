import 'package:bloc/bloc.dart';
import 'package:flyinsky/blocs/token/token_state.dart';
import 'package:flyinsky/blocs/token/token_event.dart';
import 'package:flyinsky/repository/token_repository.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState>{
  final TokenRepository tokenRepository;
  TokenBloc({required this.tokenRepository}) : super(TokenState.initial()){
    on<getToken>((event, emit)async{
      try {
        final token = await tokenRepository.getToken();
        emit(state.copyWith(tokenAccess: token));
      }catch(e){
        print(e);
      }
    });
    on<saveToken>((event, emit)async{
      try {
        final result = await tokenRepository.getAccessToken(event.code);
        await tokenRepository.saveToken(result);
      }catch(e){
        print(e);
      }
    });
    on<checkToken>((event, emit)async{
      final isExpired=await tokenRepository.isTokenExpired();
      emit(state.copyWith(isExpired: isExpired));
    });
  }
}