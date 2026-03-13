import 'expense_model.dart';

class ExpenseResponseModel {
  final String message;
  final ExpenseModel data;
  final int status;

  const ExpenseResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseResponseModel(
      message: json['message'] ?? '',
      data: ExpenseModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'status': status,
    };
  }
}