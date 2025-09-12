import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/home/domain/repos/task_repo.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_states.dart';
import '../../../../data/models/task.dart';

class TaskCubit extends Cubit<TaskStates> {
  TaskCubit(this._taskRepository) : super(TaskInitial());

  final TaskRepository _taskRepository;

  Future<void> deleteTask(String taskId) async {
    emit(DeleteTaskLoading());
    try {
      await _taskRepository.deleteTask(taskId);
      emit(DeleteTaskSuccess());
    } catch (e) {
      emit(DeleteTaskFailure(e.toString()));
    }
  }

  Future<void> editTask(TaskModel task) async {
    emit(EditTaskLoading());
    try {
      await _taskRepository.editTask(task);
      emit(EditTaskSuccess());
    } catch (e) {
      emit(EditTaskFailure(e.toString()));
    }
  }

  Future getTasks(DateTime date) async {
    emit(GetTasksLoading());
    try {
      final tasks = await _taskRepository.getTasks(date);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(GetTasksFailure(e.toString()));
    }
  }

  Future search(String name) async {
    emit(SearchTaskLoading());
    try {
      final tasks = await _taskRepository.search(name);
      emit(SearchTaskSuccess(tasks));
    } catch (e) {
      emit(SearchTaskFailure(e.toString()));
    }
  }

  Future markAsCompletedOrNot({
    required String taskId,
    required bool isCompleted,
    required DateTime date,
  }) async {
    try {
      await _taskRepository.markAsCompletedOrNot(
        taskId: taskId,
        isCompleted: isCompleted,
      );
       // getTasks(date);
      // emit(MarkAsCompletedOrNotSuccess());
    } catch (e) {
      log(e.toString());
    }
  }

  // Future getDaysOfTasks() async {
  //   emit(GetDaysOfTasksLoading());
  //   try {
  //     final days = await _taskRepository.getDaysOfTasks();
  //     emit(GetDaysOfTasksSuccess(days));
  //   } catch (e) {
  //     emit(GetDaysOfTasksFailure(e.toString()));
  //   }
  // }
}
