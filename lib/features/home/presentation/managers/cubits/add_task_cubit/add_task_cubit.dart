import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/network_reponse.dart';
import '../../../../data/models/task.dart';
import '../../../../domain/repos/task_repo.dart';
import 'add_task_states.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit(this._taskRepository) : super(AddTaskInitial());

  final TaskRepository _taskRepository;

  Future<void> addTask(TaskModel task) async {
    emit(AddTaskLoading());
    var result = await _taskRepository.addTask(task);
    switch (result) {
      case NetworkSuccess():
        emit(AddTaskSuccess());
      case NetworkFailure():
        emit(AddTaskFailure(result.exception.toString()));
    }
  }
}
