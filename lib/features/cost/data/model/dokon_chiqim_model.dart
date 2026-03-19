import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';

class DokonChiqimModel extends DokonChiqimEntity {
  const DokonChiqimModel({
    required super.id,
    required super.tolovTuri,
    required super.summa,
    super.izoh,
    super.tavsif,
    required super.sana,
  });

  factory DokonChiqimModel.fromJson(Map<String, dynamic> json) {
    return DokonChiqimModel(
      id: json['id'] ?? 0,
      tolovTuri: json['tolov_turi'] ?? '',
      summa: (json['summa'] ?? 0).toDouble(),
      izoh: json['izoh'],
      tavsif: json['tavsif'],
      sana: json['sana'] ?? '',
    );
  }
}

class CreateDokonChiqimModel extends CreateDokonChiqimEntity {
  const CreateDokonChiqimModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory CreateDokonChiqimModel.fromJson(Map<String, dynamic> json) {
    return CreateDokonChiqimModel(
      message: json['message'] ?? '',
      data: DokonChiqimModel.fromJson(json['data'] ?? {}),
      status: json['status'] ?? 0,
    );
  }
}

class DeleteDokonChiqimModel extends DeleteDokonChiqimEntity {
  const DeleteDokonChiqimModel({
    required super.message,
    required super.data,
    required super.status,
  });

  factory DeleteDokonChiqimModel.fromJson(Map<String, dynamic> json) {
    return DeleteDokonChiqimModel(
      message: json['message'] ?? '',
      data: json['data'],
      status: json['status'] ?? 0,
    );
  }
}