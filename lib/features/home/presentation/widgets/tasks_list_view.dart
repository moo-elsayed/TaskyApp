import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';
import '../../data/models/task.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({
    super.key,
    required this.searchResults,
    required this.query,
  });

  final List<TaskModel> searchResults;
  final String query;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h, bottom: 0.h),
      physics: searchResults.length < 6
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var task = searchResults[index];
        return TaskItem(task: task, search: true, query: query);
      },
      itemCount: searchResults.length,
    );
  }
}
