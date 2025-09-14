import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/helpers/dependency_injection.dart';
import 'package:tasky_app/core/services/local_notification_service.dart';
import 'package:tasky_app/simple_bloc_observer.dart';
import 'package:tasky_app/tasky_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:tasky_app/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    LocalNotificationService.init(),
  ]);
  setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  runApp(TaskyApp(appRouter: AppRouter()));
}
