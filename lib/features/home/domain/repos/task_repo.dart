import 'package:tasky_app/features/home/data/models/task.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskModel task);

  Future<void> editTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<List<TaskModel>> getAllTasks();
}
