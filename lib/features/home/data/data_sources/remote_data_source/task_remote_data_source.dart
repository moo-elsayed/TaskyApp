import '../../models/task.dart';

abstract class TaskRemoteDataSource {
  Future<void> addTask(TaskModel task);

  Future<void> editTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<List<TaskModel>> getAllTasks();

  Future<List<TaskModel>> search(String name);
}
