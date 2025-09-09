import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/task.dart';
import '../../../../domain/repos/task_repo.dart';
import 'add_task_states.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit(this._taskRepository) : super(AddTaskInitial());

  final TaskRepository _taskRepository;

  Future<void> addTask(TaskModel task) async {
    emit(AddTaskLoading());
    try {
      await _taskRepository.addTask(task);
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskFailure(e.toString()));
    }
  }
}
