import 'package:flutter/material.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/views/weatherViews/weatherView.dart';
import 'package:flyinsky/views/checklistViews/checklistView.dart';
import 'package:flyinsky/views/chartsViews/mainChartView.dart';
import 'package:flyinsky/views/profileViews/mainProfileView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';

class HomeView extends StatefulWidget {
  HomeView({required this.indexView});
  int indexView;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController pageController;

  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(androidId: 'com.dnv.flyinsky');
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) =>
            AlertDialog(
              backgroundColor: colorsPalette['card blue'],
              title: Text(
                'New version available',
                style: GoogleFonts.nunito(
                  fontSize: 24,
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
                    backgroundColor: colorsPalette['input'],
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
    pageController = PageController(initialPage: widget.indexView);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 400),
        backgroundColor: colorsPalette['input'],
        selectedIndex: widget.indexView,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() => widget.indexView = index);
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        },
        destinations: [
          NavigationDestination(icon: Icon( widget.indexView==0?Icons.cloud:Icons.cloud_outlined, size: 34, color: widget.indexView==0?colorsPalette['title']:colorsPalette['content']), label: ''),
          NavigationDestination(icon: Icon(Icons.checklist, size: 34, color: widget.indexView==1?colorsPalette['title']:colorsPalette['content']), label: ''),
          NavigationDestination(icon: Icon( widget.indexView==2?Icons.map:Icons.map_outlined, size: 34, color: widget.indexView==2?colorsPalette['title']:colorsPalette['content']), label: ''),
          NavigationDestination(icon: Icon(widget.indexView==3?Icons.person:Icons.person_outlined, size: 34, color: widget.indexView==3?colorsPalette['title']:colorsPalette['content']), label: '')
        ],
      ),
      body: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            setState(() =>  widget.indexView = index);
          },
          children: [WeatherView(), CheclistView(), Mainchartview(), MainProfileView()])
    );
  }
}
