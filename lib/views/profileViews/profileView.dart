import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/blocs/auth/auth_bloc.dart';
import 'package:flyinsky/blocs/auth/auth_event.dart';
import 'package:flyinsky/blocs/purchase/purchase_state.dart';
import 'package:flyinsky/blocs/purchase/purchase_bloc.dart';
import 'package:flyinsky/blocs/purchase/purchase_event.dart';

class ProfileView extends StatelessWidget {
  ProfileView({required this.username});

  String username;

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
        child: BlocBuilder<PurchaseBloc, PurchaseState>(
          builder: (context, purchaseState) {
            if (purchaseState.hasPurchased) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$username',
                    style: GoogleFonts.nunito(
                      color: colorsPalette['title'],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'non-ads product purchased',
                    style: GoogleFonts.nunito(
                      color: colorsPalette['title'],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 47,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      child: Text(
                        'Log out',
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
                ],
              );
            } else {
              context.read<PurchaseBloc>().add(LoadProducts());
              final products = purchaseState.products.productDetails;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$username',
                    style: GoogleFonts.nunito(
                      color: colorsPalette['title'],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical:17, horizontal: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorsPalette['dark blue'],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title,
                                  style: GoogleFonts.nunito(
                                    color: colorsPalette['title'],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product.price,
                                  style: GoogleFonts.nunito(
                                    color: colorsPalette['title'],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<PurchaseBloc>().add(
                                  MakeAndVerifyPurchase(product),
                                );
                              },
                              child: Text(
                                'Buy',
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
                                backgroundColor: colorsPalette['arrow blue'],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 47,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      child: Text(
                        'Log out',
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
