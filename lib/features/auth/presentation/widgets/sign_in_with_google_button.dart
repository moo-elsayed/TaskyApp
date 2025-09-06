import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/theming/styles.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  const ContinueWithGoogleButton({
    super.key,
    required this.on,
    this.isLoading = false,
    required this.label,
    this.indicatorColor,
  });

  final String label;
  final void Function() on;
  final bool isLoading;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w, vertical: 12.h),
      onPressed: on,
      minWidth: double.infinity,
      elevation: 0,
      color: ColorsManager.white,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Color(0xffdadce0)),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CupertinoActivityIndicator(
                color: indicatorColor ?? ColorsManager.color5F33E1,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: [
                Image.asset(
                  'assets/icons/google-icon.png',
                  height: 24.h,
                  width: 24.w,
                ),
                Text(
                  label,
                  style: TextStylesManager.font15googleSignInTextColorBold,
                ),
              ],
            ),
    );
  }
}
