import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/widgets/app_toasts.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import 'package:tasky_app/features/home/data/models/edit_task_args.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_states.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_list_tile.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/models/task.dart';
import '../widgets/custom_edit_task_container.dart';
import '../widgets/edit_name_and_description_dialog.dart';
import '../widgets/task_priority_dialog.dart';

class EditTaskView extends StatefulWidget {
  const EditTaskView({super.key, required this.editTaskArgs});

  final EditTaskArgs editTaskArgs;

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  late TaskModel task = widget.editTaskArgs.task;
  late bool _isCompleted = task.isCompleted ?? false;
  late DateTime _taskDate = task.dateTime;
  late TimeOfDay _taskTime = TimeOfDay(
    hour: task.dateTime.hour,
    minute: task.dateTime.minute,
  );
  late int _priority = task.priority;
  late String _name = task.name;
  late String _description = task.description ?? '';

  void _resetChanges() {
    _isCompleted = task.isCompleted ?? false;
    _taskDate = task.dateTime;
    _taskTime = TimeOfDay(
      hour: task.dateTime.hour,
      minute: task.dateTime.minute,
    );
    _priority = task.priority;
    _name = task.name;
    _description = task.description ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {
        if (state is DeleteTaskSuccess) {
          AppToast.showToast(
            context: context,
            title: 'Task Deleted Successfully',
            type: ToastificationType.success,
          );
          if (widget.editTaskArgs.isSearched) {
            context.read<TaskCubit>().search(widget.editTaskArgs.query!);
          } else {
            context.read<TaskCubit>().getTasks(widget.editTaskArgs.currentDay!);
          }
          context.pop();
        }
        if (state is DeleteTaskFailure || state is EditTaskFailure) {
          showErrorDialog(
            context: context,
            errorMessage: state is DeleteTaskFailure
                ? state.errorMessage
                : (state as EditTaskFailure).errorMessage,
          );
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: state is DeleteTaskLoading,
        progressIndicator: const CupertinoActivityIndicator(),
        opacity: 0.3,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, top: 24.h, right: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomEditTaskContainer(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset('assets/icons/x-icon.svg'),
                    ),
                    Gap(12.h),
                    CustomListTile(
                      name: _name,
                      description: _description,
                      onChanged: (isCompleted) {
                        _isCompleted = isCompleted;
                        setState(() {});
                      },
                      isCompleted: _isCompleted,
                      showPadding: _description.isEmpty ? false : true,
                      trailing: GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => EditNameAndDescriptionDialog(
                              initialName: _name,
                              initialDescription: _description,
                              onEdit: ({required description, required name}) {
                                _name = name;
                                _description = description;
                                setState(() {});
                              },
                            ),
                          );
                        },
                        child: SvgPicture.asset('assets/icons/edit-icon.svg'),
                      ),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle:
                          TextStylesManager.font20color24252CRegular,
                      subtitleTextStyle:
                          TextStylesManager.font16color6E6A7CRegular,
                    ),
                    Gap(30.h),
                    buildRow(
                      icon: const Icon(
                        CupertinoIcons.calendar,
                        color: ColorsManager.color5F33E1,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          barrierDismissible: false,
                          firstDate: DateTime.now(),
                          initialDate: _taskDate.isAfter(DateTime.now())
                              ? _taskDate
                              : DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                        );

                        if (pickedDate != null && pickedDate != _taskDate) {
                          _taskDate = pickedDate;
                          setState(() {});
                        }
                      },
                      title: 'Task Date: ',
                      trailingText: getDate(_taskDate),
                    ),
                    Gap(30.h),
                    buildRow(
                      icon: SvgPicture.asset('assets/icons/time-icon.svg'),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _taskTime,
                        );

                        if (pickedTime != null && pickedTime != _taskTime) {
                          _taskTime = pickedTime;
                          setState(() {});
                        }
                      },
                      title: 'Task Time: ',
                      trailingText: getTime(_taskTime),
                    ),
                    Gap(30.h),
                    buildRow(
                      icon: SvgPicture.asset('assets/icons/flag-icon.svg'),
                      onTap: () => showCupertinoDialog(
                        context: context,
                        builder: (context) => TaskPriorityDialog(
                          width: MediaQuery.widthOf(context),
                          priority: _priority,
                          onPrioritySelected: (value) {
                            _priority = value;
                            setState(() {});
                          },
                        ),
                      ),
                      title: 'Task Priority: ',
                      trailingText: _priority.toString(),
                    ),
                    Gap(30.h),
                    GestureDetector(
                      onTap: () => buildShowCupertinoDialog(context),
                      child: Row(
                        spacing: 8.w,
                        children: [
                          SvgPicture.asset('assets/icons/trash-icon.svg'),
                          Text(
                            'Delete Task',
                            style: TextStylesManager.font16colorFF4949Regular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 24.w, bottom: 24.h, right: 24.w),
            child: BlocConsumer<TaskCubit, TaskStates>(
              listener: (context, state) {
                if (state is EditTaskSuccess) {
                  AppToast.showToast(
                    context: context,
                    title: 'Task Edited Successfully',
                    type: ToastificationType.success,
                  );
                  if (widget.editTaskArgs.isSearched) {
                    context.read<TaskCubit>().search(
                      widget.editTaskArgs.query!,
                    );
                  } else {
                    context.read<TaskCubit>().getTasks(
                      widget.editTaskArgs.currentDay!,
                    );
                  }
                  context.pop();
                }
                if (state is EditTaskFailure) {
                  showErrorDialog(
                    context: context,
                    errorMessage: state.errorMessage,
                  );
                }
              },
              builder: (context, state) => Column(
                spacing: 10.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomMaterialButton(
                    onPressed: _resetChanges,
                    text: 'Reset',
                    color: ColorsManager.colorE1E0E3,
                    textStyle: TextStylesManager.font16color24252CRegular,
                  ),
                  CustomMaterialButton(
                    isLoading: state is EditTaskLoading,
                    onPressed: () {
                      context.read<TaskCubit>().editTask(
                        TaskModel(
                          dateTime: DateTime(
                            _taskDate.year,
                            _taskDate.month,
                            _taskDate.day,
                            _taskTime.hour,
                            _taskTime.minute,
                          ),
                          name: _name,
                          description: _description,
                          isCompleted: _isCompleted,
                          priority: _priority,
                          id: task.id,
                          notificationId: task.notificationId,
                        ),
                      );
                    },
                    text: 'Edit Task',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowCupertinoDialog(BuildContext context) =>
      showCupertinoDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          delete: true,
          fullText: 'Are you sure you want to delete task?',
          onTap: () {
            context.read<TaskCubit>().deleteTask(task);
            context.pop();
          },
          textOkButton: 'Delete',
        ),
      );

  Row buildRow({
    required Function()? onTap,
    required String title,
    required String trailingText,
    required Widget icon,
  }) => Row(
    spacing: 8.w,
    children: [
      icon,
      Text(title, style: TextStylesManager.font16color24252CRegular),
      const Spacer(),
      CustomEditTaskContainer(
        onTap: onTap,
        width: 70.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          trailingText,
          textAlign: TextAlign.center,
          style: TextStylesManager.font12color24252CRegular,
        ),
      ),
    ],
  );
}
