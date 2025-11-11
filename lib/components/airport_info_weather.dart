import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';

class AirportInfo extends StatelessWidget {
  AirportInfo({required this.ICAO, required this.Name, required this.altitude});

  String Name, ICAO;
  int altitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorsPalette['dark blue'],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: 5,
            color: colorsPalette['arrow blue'],
          ),
          SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 13),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Name,
                      style: GoogleFonts.nunito(
                        color: colorsPalette['title'],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Text(ICAO,
                            style: GoogleFonts.nunito(
                              color: colorsPalette['content'],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        SizedBox(width: 20),
                        Text('$altitude FT',
                            style: GoogleFonts.nunito(
                              color: colorsPalette['content'],
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 7),
          Icon(Icons.location_on, color: colorsPalette['title'], size: 34),
          SizedBox(width: 7)
        ],
      ),
    );
  }
}
