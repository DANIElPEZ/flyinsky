import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flyinsky/sqlite/sql_helper.dart';

class PurchaseRepository {
  final client = Supabase.instance.client;
  final iap=InAppPurchase.instance;

  Future<ProductDetailsResponse> fecthProducts()async{
    final products=await iap.queryProductDetails({'noads'});
    return products;
  }

  Future<bool> MakeAndverifyPurchase(ProductDetails product) async {
    final purchaseParam =PurchaseParam(productDetails: product);
    bool complete=false;
    final purchaseUpdate=iap.purchaseStream.asBroadcastStream();
    late StreamSubscription<List<PurchaseDetails>> subscription;

    subscription=purchaseUpdate.listen((purchases)async{
      for(final purchase in purchases){
        switch(purchase.status){
          case PurchaseStatus.pending:
            print('Purchase pending');
            break;
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            print('Purchase completed');
            final isValid=purchase.verificationData.serverVerificationData.isNotEmpty;
            if(isValid){
              if(purchase.pendingCompletePurchase) await iap.completePurchase(purchase);
              final db=DatabaseHelper();
              final result=await db.getAuth();
              await client.from('purchases').update({'has_purchased':true}).eq('user_id', result['user_id']);
              await db.purchasedProduct();
              return;
            }else{
              print('Verification failed');
              await subscription.cancel();
              complete=false;
              return;
            }
          case PurchaseStatus.error:
            print('Error: ${purchase.error}');
            complete=false;
            await subscription.cancel();
            return;
          case PurchaseStatus.canceled:
            print('Purchase canceled');
            complete=false;
            await subscription.cancel();
            return;
        }
      }
    });
    iap.buyNonConsumable(purchaseParam: purchaseParam);
    await Future.delayed(const Duration(seconds: 2));
    return complete;
  }

  Future<bool> hasPurchased() async {
    final db=DatabaseHelper();
    return db.isPurchased();
  }
}