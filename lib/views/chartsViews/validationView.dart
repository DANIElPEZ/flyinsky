import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/custom_input_text.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/blocs/token/token_bloc.dart';
import 'package:flyinsky/blocs/token/token_event.dart';
import 'package:google_fonts/google_fonts.dart';

class ValidationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette['light blue'],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputText(
              hintText: 'Paste code from web',
              onSubmit: (value) async{
                context.read<TokenBloc>().add(saveToken(value.trim()));
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 47,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  context.read<TokenBloc>().add(getTokenCode());
                },
                child: Text(
                  'Login with Vatsim',
                  style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: colorsPalette['dark blue'],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 47,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  context.read<TokenBloc>().add(getToken());
                  context.read<TokenBloc>().add(checkToken());
                },
                child: Text(
                  'Submit',
                  style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: colorsPalette['dark blue'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
