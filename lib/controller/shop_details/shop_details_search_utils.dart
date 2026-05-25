import 'package:app/data/datasource/model/item_model.dart';

List<Products> filterProductsByQuery(
  List<Products> source,
  String query,
) {
  final normalized = query.toLowerCase().trim();
  if (normalized.isEmpty) return List<Products>.from(source);

  return source
      .where(
        (product) => (product.name ?? '').toLowerCase().contains(normalized),
      )
      .toList();
}
