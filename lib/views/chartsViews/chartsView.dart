import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/components/custom_input_text.dart';
import 'package:flyinsky/components/expansion_panel.dart';
import 'package:flyinsky/blocs/charts/chart_bloc.dart';
import 'package:flyinsky/blocs/charts/chart_state.dart';
import 'package:flyinsky/blocs/charts/chart_event.dart';
import 'package:google_fonts/google_fonts.dart';

class chartsView extends StatefulWidget{
  @override
  State<chartsView> createState() => _chartsViewState();
}

class _chartsViewState extends State<chartsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(input: InputText(onSubmit: (value){
        context.read<chartsBloc>().add(setIcao(value));
        context.read<chartsBloc>().add(loadCharts());
      })),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorsPalette['light blue'],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: BlocBuilder<chartsBloc, chartsState>(builder: (context, state){
            if(state.charts.isNotEmpty){
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ExpandedPanel(groupedCharts: state.charts)
              );
            }if(state.charts.isEmpty && state.icao.isNotEmpty){
              return Center(child: Text('AIRPORT IS NOT AVAIABLE', style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )));
            }else{
              return Center(child: Text('SEARCH YOUR AIRPORT', style: GoogleFonts.nunito(
                color: colorsPalette['title'],
                fontSize: 20,
                fontWeight: FontWeight.bold
              )));
            }
          })
        )
    );
  }
}