import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/routing/routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
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
