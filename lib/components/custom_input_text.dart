import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';

class InputText extends StatelessWidget {
  InputText({required this.onSubmit, this.hintText});
  final void Function(String) onSubmit;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorsPalette['title'],
          selectionColor: colorsPalette['title']?.withAlpha(150),
          selectionHandleColor: colorsPalette['title']
        )
      ),
      child: TextField(
        cursorColor: colorsPalette['title'],
        style: GoogleFonts.nunito(
          color: colorsPalette['title'],
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          hintText: hintText ?? 'ICAO',
          filled: true,
          prefixIcon: Icon(Icons.search,
          color: colorsPalette['title']),
          fillColor: colorsPalette['input'],
          hintStyle: GoogleFonts.nunito(
            color: colorsPalette['title'],
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none
          )
        ),
        onSubmitted: onSubmit
      ),
    );
  }
}