import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flyinsky/utils/pdf_utils.dart';
import 'package:flyinsky/utils/ad_utils.dart';

class ViewChecklist extends StatefulWidget {
  ViewChecklist({required this.pdf_file});

  final String pdf_file;

  @override
  State<StatefulWidget> createState() => StateViewChecklist();
}

class StateViewChecklist extends State<ViewChecklist> {
  final ad_helper=adUtils();
  String? path_pdf;
  bool loading = true;

  Future<void> loadUtils() async {
    final path=await pdfUtils().loadPDF(widget.pdf_file);
    if(path!=null){
      setState(() {
        path_pdf=path;
        loading=false;
      });
    }
    if (ad_helper.isAdLoaded && !ad_helper.initialAdShown){
      ad_helper.showRewardedAd(context);
    }
  }

  @override
  void initState() {
    super.initState();
    ad_helper.loadRewardedAd(onReady: (){
      ad_helper.showRewardedAd(context);
    });
    loadUtils();
  }

  @override
  void dispose() {
    super.dispose();
    ad_helper.dispose();
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
