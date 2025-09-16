import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/features/home/data/models/edit_task_args.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_data_container.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_list_tile.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/task.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    this.onChanged,
    this.search = false,
    this.query,
  });

  final TaskModel task;
  final Function()? onChanged;
  final bool? search;
  final String? query;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _isCompleted = widget.task.isCompleted ?? false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.search == true) {
          context.pushNamed(
            Routes.editTaskView,
            arguments: EditTaskArgs(
              task: widget.task,
              query: widget.query,
              isSearched: true,
            ),
          );
        } else {
          context.pushNamed(
            Routes.editTaskView,
            arguments: EditTaskArgs(
              task: widget.task,
              currentDay: widget.task.dateTime,
              isSearched: false,
            ),
          );
        }
      },
      child: FadeInUp(
        from: 20,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.only(top: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.color6E6A7C),
          ),
          child: CustomListTile(
            name: widget.task.name,
            dateTime: widget.task.dateTime,
            onChanged: (isCompleted) async {
              _isCompleted = isCompleted;
              setState(() {});
              await context.read<TaskCubit>().markAsCompletedOrNot(
                TaskModel(
                  id: widget.task.id,
                  name: widget.task.name,
                  description: widget.task.description,
                  dateTime: widget.task.dateTime,
                  priority: widget.task.priority,
                  isCompleted: _isCompleted,
                  notificationId: widget.task.notificationId,
                ),
              );
              widget.onChanged!();
            },
            isCompleted: _isCompleted,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomDataContainer(
                  icon: SvgPicture.asset(
                    'assets/icons/flag-icon.svg',
                    height: 14.h,
                    width: 14.w,
                  ),
                  text: '${widget.task.priority}',
                ),
              ],
            ),
            subtitleTextStyle: TextStylesManager.font14color6E6A7CRegular,
            titleTextStyle: TextStylesManager.font16color404147Regular,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
          ),
        ),
      ),
    );
  }

  VisualDensity buildVisualDensity([double vertical = 0.0]) =>
      VisualDensity(horizontal: -4.w, vertical: vertical.h);
}
