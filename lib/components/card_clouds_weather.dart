import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';

class CardClouds extends StatelessWidget {
  CardClouds({required this.clouds});

  List<dynamic> clouds;

  Widget cloud(BuildContext context, cloud) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            cloud['cover'],
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorsPalette['title'],
            ),
          ),
          Text(
            cloud['base'].toString(),
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorsPalette['content'],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(vertical:17, horizontal: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorsPalette['card blue'],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clouds',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorsPalette['title'],
            ),
          ),
          SizedBox(height: 7),
          Row(
            children: List.generate(clouds.length, (index) {
              return cloud(context, clouds[index]);
            })
          )
        ],
      ),
    );
  }
}
