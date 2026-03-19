import 'package:admin_panel/features/dashboard/domain/entity/transfer_data_entity.dart';

class TransferResponseEntity {
  final String message;
  final TransferDataEntity data;
  final int status;

  TransferResponseEntity({
    required this.message,
    required this.data,
    required this.status,
  });
}