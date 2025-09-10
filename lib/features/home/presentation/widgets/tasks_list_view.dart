import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';
import '../../data/models/task.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
      itemBuilder: (context, index) {
        var task = tasks[index];
        return TaskItem(task: task);
      },
      separatorBuilder: (context, index) => Gap(16.h),
      itemCount: tasks.length,
    );
  }
}
