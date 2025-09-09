import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';

class CustomDataContainer extends StatelessWidget {
  const CustomDataContainer({
    super.key,
    required this.icon,
    required this.text,
  });

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: ColorsManager.color5F33E1),
      ),
      child: Row(
        spacing: 5.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(text, style: TextStylesManager.font12color24252CRegular),
        ],
      ),
    );
  }
}
