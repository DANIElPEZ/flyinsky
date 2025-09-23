import 'package:flutter/material.dart';
import 'package:flyinsky/views/chartsViews/validationView.dart';
import 'package:flyinsky/views/chartsViews/chartView.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/blocs/token/token_event.dart';
import 'package:flyinsky/blocs/token/token_bloc.dart';
import 'package:flyinsky/blocs/token/token_state.dart';

class Mainchartview extends StatefulWidget{
  @override
  State<Mainchartview> createState() => _ChartViewState();
}

class _ChartViewState extends State<Mainchartview> {
  @override
  void initState() {
    context.read<TokenBloc>().add(getToken());
    context.read<TokenBloc>().add(checkToken());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<TokenBloc, TokenState>(
        builder: (context, state) {
          if (state.tokenAccess.isNotEmpty && !state.isExpired) {
            return chartsView();
          } else {
            return ValidationView();
          }
        }));
  }
}