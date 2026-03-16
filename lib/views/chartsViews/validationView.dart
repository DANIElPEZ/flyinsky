import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/views/chartsViews/authVatsimView.dart';
import 'package:flyinsky/blocs/token/token_bloc.dart';
import 'package:flyinsky/blocs/token/token_event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flyinsky/repository/token_repository.dart';

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
        child: Center(
          child: SizedBox(
            height: 47,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                final String authUrl = TokenRepository().authVatsim();
                final String redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';
                final String? code = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VatsimWebView(
                          authUrl: authUrl,
                          redirectUrl: redirectUrl,
                        ),
                  ),
                );
                if (code != null) {
                  context.read<TokenBloc>().add(saveToken(code));
                  context.read<TokenBloc>().add(getToken());
                  context.read<TokenBloc>().add(checkToken());
                }
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
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: colorsPalette['dark blue'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
