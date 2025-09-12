import 'package:tasky_app/features/home/data/models/task.dart';

class EditTaskArgs {
  EditTaskArgs({
    required this.task,
    this.currentDay,
    required this.isSearched,
    this.query,
  });

  final TaskModel task;
  final DateTime? currentDay;
  final bool isSearched;
  final String? query;
}
