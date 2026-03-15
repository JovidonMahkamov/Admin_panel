import '../../domain/entity/delete_expense_entity.dart';

class DeleteExpenseModel extends DeleteExpenseEntity {
  const DeleteExpenseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteExpenseModel.fromJson(Map<String, dynamic> json) {
    return DeleteExpenseModel(
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