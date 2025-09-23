import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ViewChecklist extends StatefulWidget {
  ViewChecklist({required this.pdf_file});

  final String pdf_file;

  @override
  State<StatefulWidget> createState() => StateViewChecklist();
}

class StateViewChecklist extends State<ViewChecklist> {
  String? localPath;
  bool loading = true;
  bool isAdLoaded=false;
  RewardedAd? rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-6288821932043902/6759619816',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) async{
              ad.fullScreenContentCallback=FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad){
                    ad.dispose();
                    rewardedAd=null;
                    isAdLoaded=false;
                    loadRewardedAd();
                  },
                onAdFailedToShowFullScreenContent: (ad, e){
                    ad.dispose();
                    loadRewardedAd();
                }
              );
              setState(() {
                rewardedAd=ad;
                isAdLoaded=true;
              });
              if(isAdLoaded){
                rewardedAd?.show(onUserEarnedReward: (_, reward){
                  print(reward.amount);
                });
              }else{
                loadRewardedAd();
              }
            },
            onAdFailedToLoad: (e){
              print('Failed to load a rewarded ad: $e');
              isAdLoaded=false;
            })
    );
  }

  Future<void> loadPDF() async {
    final byteData = await rootBundle.load(
      'assets/checklist/${widget.pdf_file}',
    );
    final temDir = await getTemporaryDirectory();
    final file = await File('${temDir.path}/${widget.pdf_file}');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    setState(() {
      localPath = file.path;
      loading = false;
    });
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
                : PDFView(filePath: localPath,
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
