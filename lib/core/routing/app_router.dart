import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/features/auth/data/models/login_args.dart';
import 'package:tasky_app/features/auth/presentation/views/login_view.dart';
import 'package:tasky_app/features/auth/presentation/views/register_view.dart';
import 'package:tasky_app/features/home/presentation/views/home_view.dart';
import 'package:tasky_app/features/onboarding/presentation/views/onboarding_view.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onboardingView:
        return CupertinoPageRoute(builder: (_) => const OnboardingView());
      case Routes.loginView:
        final args = arguments as LoginArgs?;
        return CupertinoPageRoute(builder: (_) => LoginView(loginArgs: args));
      case Routes.registerView:
        return CupertinoPageRoute(builder: (_) => const RegisterView());
      case Routes.homeView:
        return CupertinoPageRoute(builder: (_) => const HomeView());
      default:
        return CupertinoPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for this ${settings.name}'),
            ),
          ),
        );
    }
  }
}
