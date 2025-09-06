import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theming/styles.dart';


class NoTasksBody extends StatelessWidget {
  const NoTasksBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(110.h),
        Image.asset('assets/images/no-tasks-image.png'),
        Gap(15.h),
        Text(
          'What do you want to do today?',
          style: TextStylesManager.font20color404147Regular,
        ),
        Gap(10.h),
        Text(
          'Tap + to add your tasks',
          style: TextStylesManager.font16color404147Regular,
        ),
      ],
    );
  }
}