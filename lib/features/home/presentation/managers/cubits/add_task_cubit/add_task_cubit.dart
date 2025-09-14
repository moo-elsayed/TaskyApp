import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/network_response.dart';
import '../../../../../../core/services/local_notification_service.dart';
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
        try {
          final notificationId =
              await LocalNotificationService.showScheduledNotification(
                task: task,
              );
          if (notificationId != null) {
            log(
              'Notification scheduled for task: ${task.name} with ID: $notificationId',
            );
            task.notificationId = notificationId;
            await _taskRepository.setNotificationId(task);
          }
          emit(AddTaskSuccess());
        } catch (e) {
          log('Error scheduling notification: $e');
          emit(AddTaskSuccess());
        }

      case NetworkFailure():
        emit(AddTaskFailure(result.exception.toString()));
    }
  }
}
