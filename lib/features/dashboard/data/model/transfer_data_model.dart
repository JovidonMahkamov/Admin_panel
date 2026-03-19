import 'package:admin_panel/features/dashboard/domain/entity/transfer_data_entity.dart';

class TransferDataModel extends TransferDataEntity {
  TransferDataModel({
    required super.naqd,
    required super.terminal,
    required super.click,
    required super.jami,
  });

  factory TransferDataModel.fromJson(Map<String, dynamic> json) {
    return TransferDataModel(
      naqd: (json['naqd'] as num?) ?? 0,
      terminal: (json['terminal'] as num?) ?? 0,
      click: (json['click'] as num?) ?? 0,
      jami: (json['jami'] as num?) ?? 0,
    );
  }
}