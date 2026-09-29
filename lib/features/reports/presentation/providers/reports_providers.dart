import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/features/reports/data/datasources/reports_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/entities/reports_summary_entity.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/repositories/reports_repository.dart';
import 'package:quan_ly_chi_tieu/features/reports/domain/usecases/watch_reports_summary_usecase.dart';

final Provider<ReportsLocalDataSource> reportsLocalDataSourceProvider =
    Provider<ReportsLocalDataSource>((Ref ref) {
      return ReportsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
    });

final Provider<ReportsRepository> reportsRepositoryProvider =
    Provider<ReportsRepository>((Ref ref) {
      return ReportsRepositoryImpl(ref.watch(reportsLocalDataSourceProvider));
    });

final Provider<WatchReportsSummaryUseCase> watchReportsSummaryUseCaseProvider =
    Provider<WatchReportsSummaryUseCase>((Ref ref) {
      return WatchReportsSummaryUseCase(ref.watch(reportsRepositoryProvider));
    });

final StreamProvider<ReportsSummaryEntity> reportsSummaryProvider =
    StreamProvider<ReportsSummaryEntity>((Ref ref) {
      return ref.watch(watchReportsSummaryUseCaseProvider).call();
    });
