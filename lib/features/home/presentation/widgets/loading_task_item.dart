import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/widgets/custom_fading_widget.dart';

class LoadingTaskItem extends StatelessWidget {
  const LoadingTaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadingWidget(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.color6E6A7C),
          color: ColorsManager.colorE6E6E6,
        ),
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: ColorsManager.colorBABABA,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: ColorsManager.colorBABABA,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  Container(
                    height: 12.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: ColorsManager.colorBABABA,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: ColorsManager.colorBABABA,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
