import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/task.dart';
import '../managers/cubits/task_cubit/task_cubit.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({
    super.key,
    this.searchResults,
    this.completedTasks,
    this.uncompletedTasks,
    this.query,
  });

  final List<TaskModel>? searchResults;
  final List<TaskModel>? completedTasks;
  final List<TaskModel>? uncompletedTasks;
  final String? query;

  @override
  Widget build(BuildContext context) {
    return searchResults != null
        ? ListView.separated(
            padding: EdgeInsets.only(top: 26.h, bottom: 0.h),
            physics: searchResults!.length < 6
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var task = searchResults![index];
              return TaskItem(
                task: task,
                search: true,
                query: query,
                onChanged: () => context.read<TaskCubit>().search(query!),
              );
            },
            separatorBuilder: (context, index) => Gap(16.h),
            itemCount: searchResults!.length,
          )
        : ListView.separated(
            padding: EdgeInsets.only(top: 26.h, bottom: 0.h),
            physics: completedTasks!.length + uncompletedTasks!.length < 6
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < uncompletedTasks!.length) {
                var task = uncompletedTasks![index];
                return TaskItem(
                  task: task,
                  onChanged: () =>
                      context.read<TaskCubit>().getTasks(task.dateTime),
                );
              } else if (index == uncompletedTasks!.length &&
                  completedTasks!.isNotEmpty) {
                return Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 76.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: ColorsManager.white,
                      border: Border.all(color: ColorsManager.color6E6A7C),
                    ),
                    child: Text(
                      'Completed',
                      style: TextStylesManager.font12color404147Regular,
                    ),
                  ),
                );
              } else if (completedTasks!.isNotEmpty) {
                int uncompletedTasksLength = uncompletedTasks!.length;
                var task = completedTasks![index - uncompletedTasksLength - 1];
                return TaskItem(
                  task: task,
                  onChanged: () =>
                      context.read<TaskCubit>().getTasks(task.dateTime),
                );
              }
              return null;
            },
            separatorBuilder: (context, index) => Gap(16.h),
            itemCount: completedTasks!.length + uncompletedTasks!.length + 1,
          );
  }
}
