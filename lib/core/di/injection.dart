import 'package:get_it/get_it.dart';

import '../../features/recording/data/recorder_service.dart';
import '../../features/recording/domain/i_recorder.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Register your dependencies here. Example:
  // getIt.registerSingleton<SomeService>(SomeServiceImpl());
  getIt.registerLazySingleton<IRecorder>(() => RecorderService());
}