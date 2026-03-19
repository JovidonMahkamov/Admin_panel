
import 'package:admin_panel/features/dashboard/data/model/transfer_data_model.dart';
import 'package:admin_panel/features/dashboard/domain/entity/transfer_response_entity.dart';

class TransferResponseModel extends TransferResponseEntity {
  TransferResponseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseModel(
      message: json['message'],
      data: TransferDataModel.fromJson(json['data']),
      status: json['status'],
    );
  }
}