import 'package:flutter/material.dart';
import 'package:flyinsky/color/colors.dart';
import 'package:flyinsky/views/weatherViews/weatherView.dart';
import 'package:flyinsky/views/checklistViews/checklistView.dart';
import 'package:flyinsky/views/chartsViews/mainChartView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:flyinsky/color/colors.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int indexView = 1;
  late PageController pageController;

  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(androidId: 'com.dnv.flyinsky');
    final status = await newVersion.getVersionStatus();
    if (//status != null && status.canUpdate ||
    true) {
      showDialog(
        context: context,
        builder:
            (contexr) =>
            AlertDialog(
              title: Text(
                'New version available',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorsPalette['title'],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async{
                    Navigator.pop(context);
                    await newVersion.launchAppStore('https://play.google.com/store/apps/details?id=com.dnv.flyinsky');
                  },
                  child: Text(
                    'Update',
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
              ],
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: indexView);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavigationBar(
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: colorsPalette['input'],
          selectedIndex: indexView,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (int index) {
            setState(() => indexView = index);
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          },
          destinations: [
            NavigationDestination(icon: Icon(indexView==0?Icons.cloud:Icons.cloud_outlined, size: 34, color: indexView==0?colorsPalette['title']:colorsPalette['content']), label: ''),
            NavigationDestination(icon: Icon(Icons.checklist, size: 34, color: indexView==1?colorsPalette['title']:colorsPalette['content']), label: ''),
            NavigationDestination(icon: Icon(indexView==2?Icons.map:Icons.map_outlined, size: 34, color: indexView==2?colorsPalette['title']:colorsPalette['content']), label: '')
          ],
        ),
        body: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              setState(() => indexView = index);
            },
            children: [WeatherView(), CheclistView(), Mainchartview()])
      ),
    );
  }
}
