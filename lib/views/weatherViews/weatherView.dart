import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/blocs/weather/weather_event.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/custom_input_text.dart';
import 'package:flyinsky/components/airport_info_weather.dart';
import 'package:flyinsky/components/card_metar_weather.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/blocs/weather/weather_state.dart';
import 'package:flyinsky/blocs/weather/weather_bloc.dart';

class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(input: InputText(onSubmit: (value){
        context.read<WeatherBloc>().add(setIcao(value));
        context.read<WeatherBloc>().add(loadWeather());
      })),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette['light blue'],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state.data!.isNotEmpty)
              return Column(
                children: [
                  AirportInfo(
                    ICAO: state.data![0]['icaoId'],
                    Name: state.data![0]['name'],
                    altitude: state.data![0]['elev']*3.281.truncate(),
                  ),
                  SizedBox(height: 20),
                  Expanded(child: CardMetar(data: state.data!)),
                ],
              );
            return loading(context);
          },
        ),
      ),
    );
  }

  Widget loading(BuildContext context) {
    return Column(
      children: [
        AirportInfo(
          Name: 'AAAAA/AAAAA AAAA, AA, AA',
          ICAO: 'AAAA',
          altitude:
          0000,
        ),
        SizedBox(height: 20),
        Expanded(child: CardMetar(data: [])),
      ],
    );
  }
}
