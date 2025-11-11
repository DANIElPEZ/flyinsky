import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flyinsky/blocs/purchase/purchase_bloc.dart';

class adUtils{
  bool isAdLoaded=false;
  bool initialAdShown = false;
  RewardedAd? rewardedAd;

  Future<void> loadRewardedAd({required void Function() onReady}) async {
    await RewardedAd.load(
      adUnitId: 'ca-app-pub-6288821932043902/6759619816',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, e) {
              ad.dispose();
            },
          );
          rewardedAd = ad;
          isAdLoaded = true;
          onReady();
        },
        onAdFailedToLoad: (e) {
          print('❌ Failed to load a rewarded ad: $e');
          isAdLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd(BuildContext context) {
    final hasPurchased = context.read<PurchaseBloc>().state.hasPurchased;
    if (isAdLoaded && rewardedAd != null && !hasPurchased) {
      rewardedAd?.show(onUserEarnedReward: (_, reward) {
        print('✅ Usuario ganó recompensa: ${reward.amount}');
      });
      isAdLoaded = false;
      initialAdShown = true;
    } else {
      print("⚠️ Anuncio no está listo todavía");
    }
  }

  void dispose() {
    rewardedAd?.dispose();
  }
}