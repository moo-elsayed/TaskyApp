import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'loading_task_item.dart';

class LoadingTasksListView extends StatelessWidget {
  const LoadingTasksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      // padding: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 26.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        return const LoadingTaskItem();
      },
    );
  }
}
