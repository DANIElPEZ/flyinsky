import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseState {
  final bool hasPurchased;
  final ProductDetailsResponse products;

  const PurchaseState({required this.hasPurchased, required this.products});

  factory PurchaseState.initial() => PurchaseState(
    hasPurchased: false,
    products: ProductDetailsResponse(
      productDetails: const <ProductDetails>[],
      notFoundIDs: const <String>[],
    ),
  );

  PurchaseState copyWith({
    bool? hasPurchased,
    ProductDetailsResponse? products,
  }) {
    return PurchaseState(
      hasPurchased: hasPurchased ?? this.hasPurchased,
      products: products ?? this.products,
    );
  }
}
