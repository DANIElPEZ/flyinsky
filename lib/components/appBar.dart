import 'package:flutter/material.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({this.input});
  final Widget? input;

  @override
  Size get preferredSize => Size.fromHeight(input != null ? 120 : 56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: colorsPalette['appbar'],
        title: Text(
          'Fly in sky',
          style: GoogleFonts.nunito(
            color: colorsPalette['title'],
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(
          Icons.flight_takeoff,
          color: colorsPalette['title'],
          size: 30,
        ),
        bottom: input!=null?PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            child: input,
          ),
        ):null
    );
  }
}