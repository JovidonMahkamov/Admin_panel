import '../../domain/entity/delete_worker_entity.dart';

class DeleteWorkerResponseModel extends DeleteWorkerResponseEntity {
  const DeleteWorkerResponseModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteWorkerResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteWorkerResponseModel(
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