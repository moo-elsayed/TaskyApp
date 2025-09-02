import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors_manager.dart';
import '../theming/styles.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({super.key, this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: ColorsManager.color5F33E1,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
      ),
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w, vertical: 12.h),
      onPressed: onPressed,
      child: Text(text, style: TextStylesManager.font16WhiteRegular),
    );
  }
}
