import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/domain/repos/task_repo.dart';
import '../data_sources/remote_data_source/task_remote_data_source.dart';

class TaskRepositoryImplementation implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImplementation(this._remoteDataSource);

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      await _remoteDataSource.addTask(task);
    } on FirebaseException catch (e) {
      throw ('Failed to add task: ${e.message}');
    } catch (e) {
      throw ('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _remoteDataSource.deleteTask(taskId);
    } on FirebaseException catch (e) {
      throw ('Failed to delete task: ${e.message}');
    } catch (e) {
      throw ('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> editTask(TaskModel task) async {
    try {
      await _remoteDataSource.editTask(task);
    } on FirebaseException catch (e) {
      throw ('Failed to delete task: ${e.message}');
    } catch (e) {
      throw ('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      return await _remoteDataSource.getAllTasks();
    } on FirebaseException catch (e) {
      throw ('Failed to get tasks: ${e.message}');
    } catch (e) {
      throw ('An unexpected error occurred: ${e.toString()}');
    }
  }
}
