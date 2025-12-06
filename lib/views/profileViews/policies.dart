import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';

class Policies extends StatelessWidget {
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Last Updated: December 5, 2025",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "This application developed by dnvdev respects and protects the personal information of its users. This app is exclusively for flight simulation purposes and must not be used in real-world conditions nor for making real aviation decisions.",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 25),
              Text(
                "1. Information Collected",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "To enable certain features and access products that remove ads within the application, we collect:",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),
              SizedBox(height: 10),

              Text("• Username",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              Text("• Password (stored in encrypted form)",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              SizedBox(height: 10),

              Text(
                "The password is encrypted before being stored in the database. We do not have access to the clear title password at any time.",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),

              SizedBox(height: 25),
              Text(
                "2. Purpose of Using the Information",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text("The collected information is used solely to:",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              SizedBox(height: 10),

              Text("• Create and authenticate your user account",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              Text("• Verify the purchase of the product that removes ads",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              Text("• Manage your access within the application",
                  style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16)),
              SizedBox(height: 10),

              Text(
                "We do not use the information for commercial or advertising purposes.",
                style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 25),
              Text(
                "3. Storage and Provider",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "The data is stored in Supabase (a secure authentication and database service). Supabase may collect technical information for performance and security purposes, such as IP address or access statistics.",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),

              SizedBox(height: 25),
              Text(
                "4. Security",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "We implement security measures such as encryption and secure data transmission. However, no system is completely invulnerable.",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),


              SizedBox(height: 25),
              Text(
                "5. Simulation Use Only",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "The information displayed in this app is for flight simulation only. It must not be used for certified training, real navigation, or real-world aviation decision-making.",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),

              SizedBox(height: 25),
              Text(
                "6. Changes to This Policy",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "We may update this policy, and any changes will be published on this page with a visible update date.",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),

              SizedBox(height: 25),
              Text(
                "7. Contact",
                style: GoogleFonts.nunito(
                  color: colorsPalette['title'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "For inquiries or requests related to your information:",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),
              SizedBox(height: 10),

              Text(
                "• Email: daniel.gonzalezubaque@gmail.com\n• Developer: dnvdev",
                style: GoogleFonts.nunito(color: colorsPalette['title'], fontSize: 16),
              ),
            ],
          ),
        ),

      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back,
            color: colorsPalette['title'],),
          backgroundColor: colorsPalette['input'],
        )
    );
  }
}
