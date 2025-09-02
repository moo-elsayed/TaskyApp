import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/routing/app_router.dart';
import 'package:tasky_app/core/routing/routes.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.onboardingView,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
