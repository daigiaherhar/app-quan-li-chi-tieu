import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_chi_tieu/core/base/result.dart';
import 'package:quan_ly_chi_tieu/core/database/database_providers.dart';
import 'package:quan_ly_chi_tieu/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:quan_ly_chi_tieu/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/entities/profile_entity.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/repositories/profile_repository.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/usecases/has_user_info_usecase.dart';
import 'package:quan_ly_chi_tieu/features/profile/domain/usecases/save_user_info_status_usecase.dart';

final Provider<ProfileLocalDataSource> profileLocalDataSourceProvider =
    Provider<ProfileLocalDataSource>((Ref ref) {
      return ProfileLocalDataSourceImpl(ref.watch(appDatabaseProvider));
    });

final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>((Ref ref) {
      return ProfileRepositoryImpl(ref.watch(profileLocalDataSourceProvider));
    });

final Provider<GetProfileUseCase> getProfileUseCaseProvider =
    Provider<GetProfileUseCase>((Ref ref) {
      return GetProfileUseCase(ref.watch(profileRepositoryProvider));
    });

final Provider<HasUserInfoUseCase> hasUserInfoUseCaseProvider =
    Provider<HasUserInfoUseCase>((Ref ref) {
      return HasUserInfoUseCase(ref.watch(profileRepositoryProvider));
    });

final Provider<SaveUserInfoStatusUseCase> saveUserInfoStatusUseCaseProvider =
    Provider<SaveUserInfoStatusUseCase>((Ref ref) {
      return SaveUserInfoStatusUseCase(ref.watch(profileRepositoryProvider));
    });

final FutureProvider<bool> hasUserInfoProvider = FutureProvider<bool>((
  Ref ref,
) async {
  final Result<bool> result = await ref.watch(hasUserInfoUseCaseProvider)();

  return result.when(
    onSuccess: (bool hasUserInfo) => hasUserInfo,
    onFailure: (String message, int statusCode, dynamic errorResponse) {
      throw Exception(message);
    },
  );
});

final FutureProvider<ProfileEntity> profileProvider =
    FutureProvider<ProfileEntity>((Ref ref) async {
      final Result<ProfileEntity> result = await ref.watch(
        getProfileUseCaseProvider,
      )();
      return result.when(
        onSuccess: (ProfileEntity profile) => profile,
        onFailure: (String message, int statusCode, dynamic errorResponse) {
          throw Exception(message);
        },
      );
    });
