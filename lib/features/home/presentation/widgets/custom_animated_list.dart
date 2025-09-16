import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';

class CustomAnimatedList extends StatefulWidget {
  const CustomAnimatedList({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  State<CustomAnimatedList> createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList> {
  late final GlobalKey<AnimatedListState> _listKey;
  late final List<TaskModel> _tasks = widget.tasks;
  late final List<TaskModel> _uncompletedTasks = _tasks
      .where((task) => task.isCompleted == false)
      .toList();
  late final List<TaskModel> _completedTasks = _tasks
      .where((task) => task.isCompleted == true)
      .toList();

  void _toggleTask(TaskModel task) {
    final oldIndex = _uncompletedTasks.indexOf(task);
    if (oldIndex != -1) {
      _uncompletedTasks.removeAt(oldIndex);
      _listKey.currentState?.removeItem(
        oldIndex,
        (_, animation) => FadeTransition(
          opacity: animation,
          child: TaskItem(task: task, onChanged: () {}),
        ),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        _completedTasks.insert(0, task..isCompleted = true);
        _completedTasks.sort((a, b) => a.priority > b.priority ? 1 : -1);
        final newIndex = _uncompletedTasks.length + 1;
        _listKey.currentState?.insertItem(newIndex);
      });
    } else {
      final completedIndex = _completedTasks.indexOf(task);
      if (completedIndex != -1) {
        _completedTasks.removeAt(completedIndex);
        final listIndex = _uncompletedTasks.length + 1 + completedIndex;
        _listKey.currentState?.removeItem(
          listIndex,
          (_, animation) => FadeTransition(
            opacity: animation,
            child: TaskItem(task: task, onChanged: () {}),
          ),
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          _uncompletedTasks.insert(0, task..isCompleted = false);
          _uncompletedTasks.sort((a, b) => a.priority > b.priority ? 1 : -1);
          _listKey.currentState?.insertItem(0);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      physics: widget.tasks.length < 6
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 10.h, bottom: 0.h),
      initialItemCount: _tasks.length + 1,
      itemBuilder: (_, index, _) {
        if (index < _uncompletedTasks.length) {
          var task = _uncompletedTasks[index];
          return TaskItem(task: task, onChanged: () => _toggleTask(task));
        } else if (index == _uncompletedTasks.length &&
            _completedTasks.isNotEmpty) {
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
        } else if (_completedTasks.isNotEmpty) {
          int uncompletedTasksLength = _uncompletedTasks.length;
          var task = _completedTasks[index - uncompletedTasksLength - 1];
          return TaskItem(task: task, onChanged: () => _toggleTask(task));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
