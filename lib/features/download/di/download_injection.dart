import 'package:get_it/get_it.dart';
import '../data/datasources/download_local_datasource.dart';
import '../data/repositories/download_repository_impl.dart';
import '../data/services/hls_download_service.dart';
import '../data/services/download_cache_service.dart';
import '../domain/repositories/download_repository.dart';
import '../domain/usecases/start_download_usecase.dart';
import '../presentation/bloc/download_bloc.dart';

final downloadGetIt = GetIt.instance;

void setupDownloadDependencies() {
  // Services
  downloadGetIt.registerLazySingleton<HlsDownloadService>(
    () => HlsDownloadService(),
  );

  // Data Sources
  downloadGetIt.registerLazySingleton<DownloadLocalDataSource>(
    () => DownloadLocalDataSourceImpl(),
  );

  // Cache Service (singleton để maintain cache across app)
  downloadGetIt.registerLazySingleton<DownloadCacheService>(
    () => DownloadCacheService(downloadGetIt<DownloadLocalDataSource>()),
  );

  // Repositories
  downloadGetIt.registerLazySingleton<DownloadRepository>(
    () => DownloadRepositoryImpl(
      localDataSource: downloadGetIt<DownloadLocalDataSource>(),
      downloadService: downloadGetIt<HlsDownloadService>(),
    ),
  );

  // Use Cases
  downloadGetIt.registerLazySingleton<StartDownloadUsecase>(
    () => StartDownloadUsecase(downloadGetIt<DownloadRepository>()),
  );

  // BLoC
  downloadGetIt.registerFactory<DownloadBloc>(
    () => DownloadBloc(downloadRepository: downloadGetIt<DownloadRepository>()),
  );
}
