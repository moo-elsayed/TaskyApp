abstract class AddTaskStates {}

class AddTaskInitial extends AddTaskStates {}

class AddTaskLoading extends AddTaskStates {}

class AddTaskSuccess extends AddTaskStates {}

class AddTaskFailure extends AddTaskStates {
  final String errorMessage;

  AddTaskFailure(this.errorMessage);
}
