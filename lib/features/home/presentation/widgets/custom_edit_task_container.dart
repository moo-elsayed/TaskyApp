import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';

class CustomEditTaskContainer extends StatelessWidget {
  const CustomEditTaskContainer({
    super.key,
    this.onTap,
    required this.child,
    this.width,
    this.padding,
  });

  final Function()? onTap;
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: ColorsManager.colorE1E0E3,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: child,
      ),
    );
  }
}
