import 'package:tasky_app/features/home/data/models/task.dart';

abstract class TaskStates {}

class TaskInitial extends TaskStates {}

class AddTaskLoading extends TaskStates {}

class AddTaskSuccess extends TaskStates {}

class AddTaskFailure extends TaskStates {
  final String errorMessage;

  AddTaskFailure(this.errorMessage);
}

class DeleteTaskLoading extends TaskStates {}

class DeleteTaskSuccess extends TaskStates {}

class DeleteTaskFailure extends TaskStates {
  final String errorMessage;

  DeleteTaskFailure(this.errorMessage);
}

class EditTaskLoading extends TaskStates {}

class EditTaskSuccess extends TaskStates {}

class EditTaskFailure extends TaskStates {
  final String errorMessage;

  EditTaskFailure(this.errorMessage);
}

class GetAllTasksLoading extends TaskStates {}

class GetAllTasksSuccess extends TaskStates {
  final List<TaskModel> tasks;

  GetAllTasksSuccess(this.tasks);
}

class GetAllTasksFailure extends TaskStates {
  final String errorMessage;

  GetAllTasksFailure(this.errorMessage);
}
