import 'package:admin_panel/features/products/data/model/product_model.dart';
import 'package:admin_panel/features/products/data/model/summary_model.dart';
import 'package:admin_panel/features/products/domain/entity/product_data_entity.dart';

class ProductDataModel extends ProductDataEntity {
  ProductDataModel({
    required super.summary,
    required super.tovarlar,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      summary: SummaryModel.fromJson(json['summary']),
      tovarlar: (json['tovarlar'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
    );
  }
}