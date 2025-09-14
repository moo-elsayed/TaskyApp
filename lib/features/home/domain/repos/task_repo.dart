import 'package:tasky_app/core/helpers/network_response.dart';
import 'package:tasky_app/features/home/data/models/task.dart';

abstract class TaskRepository {
  Future<NetworkResponse> addTask(TaskModel task);

  Future<NetworkResponse> editTask(TaskModel task);

  Future<NetworkResponse> deleteTask(String taskId);

  Future<NetworkResponse> getTasks(DateTime date);

  Future<NetworkResponse> search(String name);

  Future<NetworkResponse> markAsCompletedOrNot({
    required String taskId,
    required bool isCompleted,
  });

  Future<NetworkResponse> setNotificationId(TaskModel task);
}
