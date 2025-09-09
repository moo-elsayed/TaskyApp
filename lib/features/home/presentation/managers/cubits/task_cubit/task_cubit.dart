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

  Future getAllTasks() async {
    emit(GetAllTasksLoading());
    try {
      final tasks = await _taskRepository.getAllTasks();
      emit(GetAllTasksSuccess(tasks));
    } catch (e) {
      emit(GetAllTasksFailure(e.toString()));
    }
  }
}
