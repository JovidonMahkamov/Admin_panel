import 'package:admin_panel/features/products/domain/entity/product_entity.dart';
import 'package:admin_panel/features/products/domain/entity/summary_entity.dart';

class ProductDataEntity {
  final SummaryEntity summary;
  final List<ProductEntity> tovarlar;

  ProductDataEntity({
    required this.summary,
    required this.tovarlar,
  });
}