import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/home/domain/repos/task_repo.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_states.dart';
import '../../../../../../core/helpers/network_reponse.dart';
import '../../../../data/models/task.dart';

class TaskCubit extends Cubit<TaskStates> {
  TaskCubit(this._taskRepository) : super(TaskInitial());

  final TaskRepository _taskRepository;

  Future<void> deleteTask(String taskId) async {
    emit(DeleteTaskLoading());
    var result = await _taskRepository.deleteTask(taskId);
    switch (result) {
      case NetworkSuccess():
        emit(DeleteTaskSuccess());
      case NetworkFailure():
        emit(DeleteTaskFailure(result.exception.toString()));
    }
  }

  Future<void> editTask(TaskModel task) async {
    emit(EditTaskLoading());
    var result = await _taskRepository.editTask(task);
    switch (result) {
      case NetworkSuccess():
        emit(EditTaskSuccess());
      case NetworkFailure():
        emit(EditTaskFailure(result.exception.toString()));
    }
  }

  Future getTasks(DateTime date) async {
    emit(GetTasksLoading());
    var result = await _taskRepository.getTasks(date);
    switch (result) {
      case NetworkSuccess():
        emit(GetTasksSuccess(result.data));
      case NetworkFailure():
        emit(GetTasksFailure(result.exception.toString()));
    }
  }

  Future search(String name) async {
    emit(SearchTaskLoading());
    var result = await _taskRepository.search(name);
    switch (result) {
      case NetworkSuccess():
        emit(SearchTaskSuccess(result.data));
      case NetworkFailure():
        emit(SearchTaskFailure(result.exception.toString()));
    }
  }

  Future markAsCompletedOrNot({
    required String taskId,
    required bool isCompleted,
    required DateTime date,
  }) async {
    var result = await _taskRepository.markAsCompletedOrNot(
      taskId: taskId,
      isCompleted: isCompleted,
    );
    switch (result) {
      case NetworkSuccess():
        return;
      case NetworkFailure():
        log(result.exception.toString());
    }
  }
}
