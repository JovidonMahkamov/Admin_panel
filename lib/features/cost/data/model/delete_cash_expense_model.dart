import '../../domain/entity/delete_cash_expense_entity.dart';

class DeleteCashExpenseModel extends DeleteCashExpenseEntity {
  const DeleteCashExpenseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteCashExpenseModel.fromJson(Map<String, dynamic> json) {
    return DeleteCashExpenseModel(
      message: json['message'] ?? '',
      data: json['data'],
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'status': status,
    };
  }
}