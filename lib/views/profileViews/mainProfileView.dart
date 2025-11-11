import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_state.dart';
import 'package:flyinsky/blocs/auth/auth_event.dart';
import 'package:flyinsky/blocs/purchase/purchase_bloc.dart';
import 'package:flyinsky/blocs/purchase/purchase_event.dart';
import 'package:flyinsky/views/profileViews/LoginView.dart';
import 'package:flyinsky/views/profileViews/profileView.dart';

class MainProfileView extends StatefulWidget{
  @override
  State<MainProfileView> createState() => _MainProfileViewState();
}

class _MainProfileViewState extends State<MainProfileView> {

  @override
  void initState() {
    context.read<AuthBloc>().add(getUserRequested());
    context.read<PurchaseBloc>().add(LoadHasPurchase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if(state.isAuthenticated){
        final username = context.watch<AuthBloc>().state.username;
        return ProfileView(username: username);
      }else{
        return LoginView();
      }
    });
  }
}