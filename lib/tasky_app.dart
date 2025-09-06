import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/routing/app_router.dart';
import 'package:tasky_app/features/auth/data/repos/firebase_auth_repo_imp.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_cubit.dart';
import 'core/routing/routes.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key, required this.appRouter, required this.firstTime});

  final AppRouter appRouter;
  final bool firstTime;

  String _getInitialRoute() {
    if (firstTime) {
      return Routes.onboardingView;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return Routes.homeView;
    } else {
      return Routes.loginView;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => AuthCubit(FirebaseAuthRepositoryImplementation()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: _getInitialRoute(),
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}
