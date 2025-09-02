import 'package:flutter/material.dart';
import 'package:tasky_app/core/routing/app_router.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false);
  }
}
