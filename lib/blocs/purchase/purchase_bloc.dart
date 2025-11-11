import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/blocs/purchase/purchase_state.dart';
import 'package:flyinsky/blocs/purchase/purchase_event.dart';
import 'package:flyinsky/repository/purchase_repository.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;
  late StreamSubscription<dynamic> streamSubscription;

  PurchaseBloc({required this.purchaseRepository}) : super(PurchaseState.initial()) {
    on<LoadProducts>((event, emit) async {
      final products=await purchaseRepository.fecthProducts();
      emit(state.copyWith(products: products));
    });
    on<LoadHasPurchase>((event, emit) async {
      final isPurchased=await purchaseRepository.hasPurchased();
      emit(state.copyWith(hasPurchased: isPurchased));
    });
    on<MakeAndVerifyPurchase>((event, emit) async {
      final success=await purchaseRepository.MakeAndverifyPurchase(event.product);
      if(success) emit(state.copyWith(hasPurchased: true));
    });
  }
}
