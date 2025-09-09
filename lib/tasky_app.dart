import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/routing/app_router.dart';
import 'package:tasky_app/features/auth/data/repos/firebase_auth_repo_imp.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_cubit.dart';
import 'core/helpers/dependency_injection.dart';
import 'core/routing/routes.dart';
import 'features/home/data/repos/task_repo_imp.dart';
import 'features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TaskCubit(getIt.get<TaskRepositoryImplementation>()),
          ),
          BlocProvider(
            create: (context) =>
                AuthCubit(getIt.get<FirebaseAuthRepositoryImplementation>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.animatedSplashView,
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}
