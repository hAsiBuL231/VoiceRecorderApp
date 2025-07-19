import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'bloc/recorder_bloc.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;

  const MyApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecorderBloc(AudioService(), hiveService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Voice Recorder',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
          cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
