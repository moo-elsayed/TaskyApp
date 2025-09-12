import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/task.dart';
import '../managers/cubits/task_cubit/task_cubit.dart';

class TasksListView extends StatefulWidget {
  const TasksListView({
    super.key,
    this.searchResults,
    this.completedTasks,
    this.uncompletedTasks,
  });

  final List<TaskModel>? searchResults;
  final List<TaskModel>? completedTasks;
  final List<TaskModel>? uncompletedTasks;

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  @override
  Widget build(BuildContext context) {
    return widget.searchResults != null
        ? ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 26.h),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var task = widget.searchResults![index];
              return TaskItem(
                task: task,
                onChanged: () =>
                    context.read<TaskCubit>().search(task.name),
              );
            },
            separatorBuilder: (context, index) => Gap(16.h),
            itemCount: widget.searchResults!.length,
          )
        : ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 26.h),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index < widget.uncompletedTasks!.length) {
                var task = widget.uncompletedTasks![index];
                return TaskItem(
                  task: task,
                  onChanged: () =>
                      context.read<TaskCubit>().getTasks(task.dateTime),
                );
              } else if (index == widget.uncompletedTasks!.length &&
                  widget.completedTasks!.isNotEmpty) {
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
              } else if (widget.completedTasks!.isNotEmpty) {
                int uncompletedTasksLength = widget.uncompletedTasks!.length;
                var task =
                    widget.completedTasks![index - uncompletedTasksLength - 1];
                return TaskItem(
                  task: task,
                  onChanged: () =>
                      context.read<TaskCubit>().getTasks(task.dateTime),
                );
              }
              return null;
            },
            separatorBuilder: (context, index) => Gap(16.h),
            itemCount:
                widget.completedTasks!.length +
                widget.uncompletedTasks!.length +
                1,
          );
  }
}
