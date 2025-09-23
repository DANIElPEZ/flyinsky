import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/views/checklistViews/cheklistProceduresView.dart';

class CardAircraft extends StatelessWidget{
  CardAircraft({required this.title, required this.pdf_file});
  String title, pdf_file;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewChecklist(pdf_file: pdf_file))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 14),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorsPalette['card blue'],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorsPalette['title'],
              ),
            ),
            Icon(Icons.flight,
            color: colorsPalette['title'],
            size: 30),
          ],
        ),
      ),
    );
  }
}