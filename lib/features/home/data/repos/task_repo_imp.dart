import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/domain/repos/task_repo.dart';
import '../../../../core/helpers/network_reponse.dart';
import '../data_sources/remote_data_source/task_remote_data_source.dart';

class TaskRepositoryImplementation implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImplementation(this._remoteDataSource);

  @override
  Future<NetworkResponse> addTask(TaskModel task) async {
    try {
      await _remoteDataSource.addTask(task);
      return NetworkSuccess();
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to add task: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<NetworkResponse> deleteTask(String taskId) async {
    try {
      await _remoteDataSource.deleteTask(taskId);
      return NetworkSuccess();
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to delete task: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<NetworkResponse> editTask(TaskModel task) async {
    try {
      await _remoteDataSource.editTask(task);
      return NetworkSuccess();
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to edit task: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<NetworkResponse> getTasks(DateTime date) async {
    try {
      List<TaskModel> result = await _remoteDataSource.getTasks(date);
      return NetworkSuccess(data: result);
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to get tasks: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<NetworkResponse> search(String name) async {
    try {
      List<TaskModel> result = await _remoteDataSource.search(name);
      return NetworkSuccess(data: result);
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to get tasks: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<NetworkResponse> markAsCompletedOrNot({
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      await _remoteDataSource.markAsCompletedOrNot(
        taskId: taskId,
        isCompleted: isCompleted,
      );
      return NetworkSuccess();
    } on FirebaseException catch (e) {
      return NetworkFailure(Exception('Failed to complete task: ${e.message}'));
    } catch (e) {
      return NetworkFailure(
        Exception('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
