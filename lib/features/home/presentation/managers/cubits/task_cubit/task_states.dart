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

class GetTasksLoading extends TaskStates {}

class GetTasksSuccess extends TaskStates {
  final List<TaskModel> tasks;

  GetTasksSuccess(this.tasks);
}

class GetTasksFailure extends TaskStates {
  final String errorMessage;

  GetTasksFailure(this.errorMessage);
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

// class GetDaysOfTasksLoading extends TaskStates {}
//
// class GetDaysOfTasksSuccess extends TaskStates {
//   final List<DateTime> days;
//   GetDaysOfTasksSuccess(this.days);
// }
//
// class GetDaysOfTasksFailure extends TaskStates {
//   final String errorMessage;
//   GetDaysOfTasksFailure(this.errorMessage);
// }

class MarkAsCompletedOrNotSuccess extends TaskStates {}