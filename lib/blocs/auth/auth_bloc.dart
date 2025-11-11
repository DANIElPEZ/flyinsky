import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_event.dart';
import 'package:flyinsky/blocs/auth/auth_state.dart';
import 'package:flyinsky/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authrepository;

  AuthBloc({required this.authrepository}) : super(AuthState.initial()) {
    on<SignUpRequested>((event, emit) async{
      try {
        await authrepository.signUp(event.username, event.password);
        emit(state.copyWith(isAuthenticated: true));
      } catch (e) {
        print(e);
      }
    });
    on<SignInRequested>((event, emit) async{
      try {
        await authrepository.signIn(event.username, event.password);
        emit(state.copyWith(isAuthenticated: true));
      } catch (e) {
        print(e);
      }
    });
    on<SignOutRequested>((event, emit)async{
      emit(AuthState.initial());
      await authrepository.logOut();
    });
    on<getUserRequested>((event, emit)async{
      final result=await authrepository.getUser();
      if(result.isNotEmpty){
        emit(state.copyWith(isAuthenticated: true, username: result['username']));
      }
    });
  }
}