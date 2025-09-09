import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_data_container.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_list_tile.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/task.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.pushNamed(Routes.editTaskView, arguments: widget.task),
      child: FadeInUp(
        from: 20,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.color6E6A7C),
          ),
          child: CustomListTile(
            task: widget.task,
            onChanged: (isCompleted) {
              log(isCompleted.toString());
            },
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
