import 'package:admin_panel/features/cost/domain/entity/dokon_chiqim_entity.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';

class GetDokonChiqimUseCase {
  final CostRepo repo;
  GetDokonChiqimUseCase(this.repo);

  Future<List<DokonChiqimEntity>> call({String? tolovTuri}) =>
      repo.getDokonChiqim(tolovTuri: tolovTuri);
}

class PostDokonChiqimUseCase {
  final CostRepo repo;
  PostDokonChiqimUseCase(this.repo);

  Future<CreateDokonChiqimEntity> call({
    required String tolovTuri,
    required double summa,
    String? izoh,
    String? tavsif,
  }) =>
      repo.postDokonChiqim(tolovTuri: tolovTuri, summa: summa, izoh: izoh, tavsif: tavsif);
}

class PatchDokonChiqimUseCase {
  final CostRepo repo;
  PatchDokonChiqimUseCase(this.repo);

  Future<CreateDokonChiqimEntity> call({
    required int id,
    String? tolovTuri,
    double? summa,
    String? izoh,
    String? tavsif,
  }) =>
      repo.patchDokonChiqim(id: id, tolovTuri: tolovTuri, summa: summa, izoh: izoh, tavsif: tavsif);
}

class DeleteDokonChiqimUseCase {
  final CostRepo repo;
  DeleteDokonChiqimUseCase(this.repo);

  Future<DeleteDokonChiqimEntity> call({required int id}) =>
      repo.deleteDokonChiqim(id: id);
}