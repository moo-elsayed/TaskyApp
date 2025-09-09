import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';

class CustomPriorityItem extends StatelessWidget {
  const CustomPriorityItem({
    super.key,
    this.onTap,
    required this.isSelected,
    required this.number,
  });

  final void Function()? onTap;
  final bool isSelected;
  final String number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: isSelected ? ColorsManager.color5F33E1 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
            side: BorderSide(
              color: isSelected
                  ? ColorsManager.color5F33E1
                  : ColorsManager.color6E6A7C,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.h,
          children: [
            SvgPicture.asset(
              'assets/icons/flag-icon.svg',
              colorFilter: isSelected
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null,
            ),
            Text(
              number,
              style: isSelected
                  ? TextStylesManager.font16WhiteRegular
                  : TextStylesManager.font16color404147Regular,
            ),
          ],
        ),
      ),
    );
  }
}
