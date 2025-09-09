import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_states.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_list_tile.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../data/models/task.dart';
import '../widgets/custom_edit_task_container.dart';
import '../widgets/task_priority_dialog.dart';

class EditTaskView extends StatefulWidget {
  const EditTaskView({super.key, required this.task});

  final TaskModel task;

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  late bool _isCompleted = widget.task.isCompleted ?? false;
  late DateTime _taskDate = widget.task.dateTime;
  late TimeOfDay _taskTime = TimeOfDay(
    hour: widget.task.dateTime.hour,
    minute: widget.task.dateTime.minute,
  );
  final _formKey = GlobalKey<FormState>();
  late int _priority = widget.task.priority;
  late final _nameController = TextEditingController(text: widget.task.name);
  late final _descriptionController = TextEditingController(
    text: widget.task.description,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, top: 24.h, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomEditTaskContainer(
                onTap: () => context.pop(),
                child: SvgPicture.asset('assets/icons/x-icon.svg'),
              ),
              Gap(12.h),
              CustomListTile(
                task: widget.task,
                onChanged: (isCompleted) {
                  _isCompleted = isCompleted;
                },
                trailing: SvgPicture.asset('assets/icons/edit-icon.svg'),
                contentPadding: EdgeInsets.zero,
                titleTextStyle: TextStylesManager.font20color24252CRegular,
                subtitleTextStyle: TextStylesManager.font16color6E6A7CRegular,
                showDescription: true,
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
                    initialDate: _taskDate,
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
              BlocListener<TaskCubit, TaskStates>(
                listener: (context, state) {
                  if (state is DeleteTaskSuccess) {
                    context.read<TaskCubit>().getAllTasks();
                    context.pop();
                  }
                  if (state is DeleteTaskFailure) {
                    showCustomToast(
                      context: context,
                      message: state.errorMessage,
                      contentType: ContentType.failure,
                    );
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => ConfirmationDialog(
                        delete: true,
                        fullText: 'Are you sure you want to delete task?',
                        onTap: () {
                          context.read<TaskCubit>().deleteTask(widget.task.id!);
                          context.pop();
                        },
                        textOkButton: 'Delete',
                      ),
                    );
                  },
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
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 24.w, bottom: 24.h, right: 24.w),
        child: BlocConsumer<TaskCubit, TaskStates>(
          listener: (context, state) {
            if (state is EditTaskSuccess) {
              context.read<TaskCubit>().getAllTasks();
              context.pop();
            }
            if (state is GetAllTasksFailure) {
              showCustomToast(
                context: context,
                message: state.errorMessage,
                contentType: ContentType.failure,
              );
            }
          },
          builder: (context, state) => CustomMaterialButton(
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
                  name: _nameController.text,
                  description: _descriptionController.text,
                  isCompleted: _isCompleted,
                  priority: _priority,
                  id: widget.task.id,
                ),
              );
            },
            text: 'Edit Task',
          ),
        ),
      ),
    );
  }

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
