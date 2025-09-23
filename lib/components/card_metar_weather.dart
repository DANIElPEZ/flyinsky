import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/compass_weather.dart';
import 'package:flyinsky/components/card_info_weather.dart';
import 'package:flyinsky/components/card_clouds_weather.dart';

class CardMetar extends StatelessWidget {
  CardMetar({required this.data});

  List<dynamic>? data;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> metar = {};
    if (data!.isNotEmpty) {
      metar['date'] = data?[0]['reportTime'];
      metar['raw'] = data?[0]['rawOb'];
      metar['wind direction'] =
          data?[0]['wdir'].runtimeType == String ? 0 : data?[0]['wdir'];
      metar['wind speed'] = data?[0]['wspd'];
      metar['temperature'] = data?[0]['temp'];
      metar['dew point'] = data?[0]['dewp'];
      metar['qnh'] = data?[0]['altim'];
      metar['inhg'] = (metar['qnh']! * 0.02953).toString().substring(0,5);
      metar['visibility'] = data?[0]['visib'];
      metar['clouds'] = data?[0]['clouds'];
    } else {
      metar['date'] = '0000-00-00 00:00:00';
      metar['raw'] =
          'AAAA 000000Z 000000KT 0000 AAAA WWW000AA 00/00 Q0000 AAA AA/A';
      metar['wind direction'] = 0;
      metar['wind speed'] = 0;
      metar['temperature'] = '00';
      metar['dew point'] = '00';
      metar['qnh'] = '0000';
      metar['inhg'] = '00.00';
      metar['visibility'] = '0000';
      metar['clouds'] = [
        {'cover': 'AAA', 'base': '0000'},
        {'cover': 'AAA', 'base': '0000'},
        {'cover': 'AAA', 'base': '0000'},
        {'cover': 'AAA', 'base': '0000'},
      ];
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorsPalette['dark blue'],
      ),
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                'Metar Information',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorsPalette['title'],
                ),
              ),
              Text(
                metar['date'],
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorsPalette['content'],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorsPalette['card blue'],
                ),
                child: Text(
                  metar['raw'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorsPalette['title'],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Compass(
                    direction: metar['wind direction'],
                    speed: metar['wind speed'],
                  ),
                  SizedBox(height: 12),
                  CardInfo(
                    title: 'Temperature / Dew Point',
                    content:
                        '${metar['temperature']}°C / ${metar['dew point']}°C',
                  ),
                  SizedBox(height: 8),
                  CardInfo(
                    title: 'QNH / INHG',
                    content: '${metar['qnh']} QNH / ${metar['inhg']} INHG',
                  ),
                  SizedBox(height: 8),
                  CardInfo(
                    title: 'Visibility',
                    content: '${(metar['visibility'])}',
                  ),
                  SizedBox(height: 8),
                  CardClouds(clouds: metar['clouds']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
