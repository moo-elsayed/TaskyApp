import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.slidesLength,
    required this.currentIndex,
  });

  final int slidesLength;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        slidesLength,
        (index) => buildIndicator(
          index: index,
          context: context,
          lastItem: index == slidesLength - 1,
        ),
      ),
    );
  }

  Container buildIndicator({
    required int index,
    required BuildContext context,
    required bool lastItem,
  }) {
    bool isSelected = currentIndex == index;
    return Container(
      height: 4.h,
      width: 26.w,
      margin: EdgeInsets.only(right: lastItem ? 0 : 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(56.r),
        shape: BoxShape.rectangle,
        color: isSelected
            ? ColorsManager.color744EE5
            : ColorsManager.colorAFAFAF,
      ),
    );
  }
}
