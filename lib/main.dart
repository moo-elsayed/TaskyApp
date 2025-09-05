import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/simple_bloc_observer.dart';
import 'package:tasky_app/tasky_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/helpers/shared_preferences_manager.dart';
import 'firebase_options.dart';
import 'package:tasky_app/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  final firstTime = await Future.wait([
    SharedPreferencesManager.getFirstTime(),
  ]);
  runApp(TaskyApp(appRouter: AppRouter(), firstTime: firstTime[0]));
}
