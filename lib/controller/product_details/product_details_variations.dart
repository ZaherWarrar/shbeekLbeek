import 'package:app/data/datasource/model/product_details_model.dart';

void applyDefaultVariations({
  required ProductDetailsModel? product,
  required List<ProductVariationModel> selectedVariations,
}) {
  if ((product?.type ?? '').toLowerCase() == 'variable' &&
      (product?.variations.isNotEmpty ?? false)) {
    if (selectedVariations.isEmpty) {
      selectedVariations.add(product!.variations.first);
    }
  } else {
    selectedVariations.clear();
  }
}

void toggleVariationSelection({
  required List<ProductVariationModel> selected,
  required ProductVariationModel variation,
}) {
  final idx = selected.indexWhere(
    (e) => e.id == variation.id && e.name == variation.name,
  );
  if (idx == -1) {
    selected.add(variation);
  } else {
    selected.removeAt(idx);
  }
}

String? combinedVariationNames(List<ProductVariationModel> selected) {
  final names = selected
      .map((e) => (e.name ?? '').trim())
      .where((s) => s.isNotEmpty)
      .toList();
  if (names.isEmpty) return null;
  return names.join(', ');
}
