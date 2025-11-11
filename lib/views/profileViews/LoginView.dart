import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/components/custom_input_text.dart';
import 'package:flyinsky/blocs/auth/auth_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_event.dart';

class LoginView extends StatelessWidget {
  String? username;
  String? password;

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
              icon: Icons.person,
              hintText: 'username',
              onSubmit: (_) {},
              onChanged: (value) async {
                username = value;
              },
            ),
            SizedBox(height: 13),
            InputText(
              icon: Icons.key,
              hintText: 'Password',
              onSubmit: (_) {},
              onChanged: (value) async {
                password = value;
              },
            ),
            SizedBox(height: 20),
            SizedBox(
                height: 47,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignInRequested(username!, password!)
                      );
                    },
                    child: Text(
                      'Sign In',
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
                        backgroundColor: colorsPalette['dark blue']
                    )
                )
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 47,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    SignUpRequested(username!, password!),
                  );
                },
                child: Text(
                  'Sign Up',
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
                  backgroundColor: colorsPalette['dark blue']
                )
              )
            )
          ]
        )
      )
    );
  }
}
