import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';

class CardInfo extends StatelessWidget {
  CardInfo({required this.title, required this.content});

  String title, content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorsPalette['card blue'],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorsPalette['title'],
            ),
          ),
          SizedBox(height: 7),
          Text(
            content,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: colorsPalette['content'],
            ),
          )
        ],
      ),
    );
  }
}
