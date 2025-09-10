import 'package:tasky_app/features/home/data/models/task.dart';

abstract class TaskStates {}

class TaskInitial extends TaskStates {}

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

class SearchTaskLoading extends TaskStates {}

class SearchTaskSuccess extends TaskStates {
  final List<TaskModel> tasks;

  SearchTaskSuccess(this.tasks);
}

class SearchTaskFailure extends TaskStates {
  final String errorMessage;

  SearchTaskFailure(this.errorMessage);
}
