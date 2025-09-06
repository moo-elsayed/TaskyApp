import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomAnimationWidget extends StatelessWidget {
  const CustomAnimationWidget({
    super.key,
    required this.index,
    required this.delay,
    required this.child,
  });

  final int index;
  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return index == 0
        ? FadeInLeft(
            delay: Duration(milliseconds: delay),
            from: 50,
            child: child,
          )
        : index == 1
        ? FadeInDown(
            delay: Duration(milliseconds: delay),
            from: 50,
            child: child,
          )
        : FadeInRight(
            delay: Duration(milliseconds: delay),
            from: 50,
            child: child,
          );
  }
}
