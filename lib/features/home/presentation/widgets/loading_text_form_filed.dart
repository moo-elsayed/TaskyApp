import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/widgets/custom_fading_widget.dart';

class LoadingTextFormField extends StatelessWidget {
  const LoadingTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadingWidget(
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: ColorsManager.colorE6E6E6,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: ColorsManager.color6E6A7C),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            // icon placeholder
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: ColorsManager.colorBABABA,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(width: 12.w),
            // text placeholder
            Expanded(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: ColorsManager.colorBABABA,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
