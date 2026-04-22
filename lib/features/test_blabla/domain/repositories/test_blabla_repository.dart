import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/features/test_blabla/domain/entities/test_blabla_entity.dart';

abstract class TestBlablaRepository {
  Future<Result<TestBlablaEntity>> getTestBlabla();
}
