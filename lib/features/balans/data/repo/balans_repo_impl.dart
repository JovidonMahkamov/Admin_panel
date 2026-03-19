import 'package:admin_panel/features/balans/data/datasource/balans_data_source.dart';
import 'package:admin_panel/features/balans/domain/entity/balans_entity.dart';
import 'package:admin_panel/features/balans/domain/repo/balans_repo.dart';

class BalansRepositoryImpl implements BalansRepository {
  final BalansDataSource remote;

  BalansRepositoryImpl({required this.remote});

  @override
  Future<BalansEntity> getBalans() => remote.getBalans();
}