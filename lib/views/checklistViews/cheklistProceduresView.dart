import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ViewChecklist extends StatefulWidget {
  ViewChecklist({required this.pdf_file});

  final String pdf_file;

  @override
  State<StatefulWidget> createState() => StateViewChecklist();
}

class StateViewChecklist extends State<ViewChecklist> {
  String? path_pdf;
  bool loading = true;
  bool isAdLoaded=false;
  RewardedAd? rewardedAd;
  bool initialAdShown = false;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-6288821932043902/6759619816',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAd = null;
              isAdLoaded = false;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, e) {
              ad.dispose();
              loadRewardedAd();
            },
          );

          setState(() {
            rewardedAd = ad;
            isAdLoaded = true;
          });
          if (!loading && !initialAdShown) {
            showRewardedAd();
          }
        },
        onAdFailedToLoad: (e) {
          print('Failed to load a rewarded ad: $e');
          isAdLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd() {
    if (isAdLoaded && rewardedAd != null) {
      rewardedAd?.show(onUserEarnedReward: (_, reward) {
        print('Usuario ganó recompensa: ${reward.amount}');
      });
      isAdLoaded = false;
      initialAdShown = true;
    } else {
      print("Anuncio no está listo todavía");
    }
  }

  Future<void> loadPDF() async {
    try{
      final ioClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      final client = IOClient(ioClient);
      final response = await client.get(Uri.parse(widget.pdf_file));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/chart.pdf');
        await file.writeAsBytes(response.bodyBytes, flush: true);
        setState(() {
          path_pdf = file.path;
          loading = false;
        });
      }else {
        throw Exception('Error al descargar PDF: ${response.statusCode}');
      }
      if (isAdLoaded && !initialAdShown) {
        showRewardedAd();
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadRewardedAd();
    loadPDF();
  }

  @override
  void dispose() {
    rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette['light blue'],
        child:
            loading
                ? Center(child: CircularProgressIndicator())
                : PDFView(filePath: path_pdf,
            swipeHorizontal: true
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
