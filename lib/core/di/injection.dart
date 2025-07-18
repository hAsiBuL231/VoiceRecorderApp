import 'package:get_it/get_it.dart';

import '../../features/recording/data/hive_recording_datasource.dart';
import '../../features/recording/data/recorder_service.dart';
import '../../features/recording/data/recording_repository_implementation.dart';
import '../../features/recording/domain/i_recorder.dart';
import '../../features/recording/domain/recording_repository.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<HiveRecordingDatasource>(() => HiveRecordingDatasource());
  getIt.registerLazySingleton<RecordingRepository>(() => RecordingRepositoryImpl(getIt()));
  getIt.registerLazySingleton<IRecorder>(() => RecorderService(getIt()));
}
