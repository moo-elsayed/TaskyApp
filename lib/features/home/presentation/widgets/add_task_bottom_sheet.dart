import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/helpers/vaildator.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/core/widgets/custom_toast.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/add_task_cubit/add_task_cubit.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/add_task_cubit/add_task_states.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_priority_dialog.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
import '../../../../core/utils/functions.dart';
import '../managers/cubits/task_cubit/task_cubit.dart';
import 'custom_data_container.dart';
import 'custom_error_dialog.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _currentDate;
  TimeOfDay? _currentTime;
  final _formKey = GlobalKey<FormState>();
  int? _priority;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          showCustomToast(
            context: context,
            message: 'Task added successfully',
            contentType: ContentType.success,
          );
          context.read<TaskCubit>().getAllTasks();
          context.pop();
        }
        if (state is AddTaskFailure) {
          showErrorDialog(context: context, errorMessage: state.errorMessage);
        }
      },
      builder: (context, state) => Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.w,
                right: 25.w,
                top: 25.h,
                bottom: 17.h + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Task',
                      style: TextStylesManager.font20color404147Bold,
                    ),
                    Gap(14.h),
                    TextFormFieldHelper(
                      controller: _titleController,
                      borderRadius: BorderRadius.circular(4.r),
                      hint: 'Title',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      action: TextInputAction.next,
                      onValidate: Validator.validateName,
                    ),
                    Gap(12.h),
                    TextFormFieldHelper(
                      controller: _descriptionController,
                      borderRadius: BorderRadius.circular(4.r),
                      hint: 'Description',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      action: TextInputAction.done,
                    ),
                    Gap(20.h),
                    Row(
                      spacing: 12.w,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              barrierDismissible: false,
                              firstDate: DateTime.now(),
                              initialDate: _currentDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365 * 5),
                              ),
                            );

                            if (pickedDate != null &&
                                pickedDate != _currentDate) {
                              _currentDate = pickedDate;
                              setState(() {});
                            }
                          },

                          child: _currentDate == null
                              ? const Icon(
                                  CupertinoIcons.calendar,
                                  color: ColorsManager.color5F33E1,
                                )
                              : CustomDataContainer(
                                  icon: Icon(
                                    CupertinoIcons.calendar,
                                    color: ColorsManager.color5F33E1,
                                    size: 14.r,
                                  ),
                                  text: getDate(_currentDate!),
                                ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,

                              initialTime: _currentTime ?? TimeOfDay.now(),
                            );

                            if (pickedTime != null &&
                                pickedTime != _currentTime) {
                              _currentTime = pickedTime;
                              setState(() {});
                            }
                          },
                          child: _currentTime == null
                              ? SvgPicture.asset('assets/icons/time-icon.svg')
                              : CustomDataContainer(
                                  icon: SvgPicture.asset(
                                    'assets/icons/time-icon.svg',
                                    height: 14.h,
                                    width: 14.w,
                                  ),
                                  text: getTime(_currentTime!),
                                ),
                        ),
                        GestureDetector(
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
                          child: _priority == null
                              ? SvgPicture.asset('assets/icons/flag-icon.svg')
                              : CustomDataContainer(
                                  icon: SvgPicture.asset(
                                    'assets/icons/flag-icon.svg',
                                    height: 14.h,
                                    width: 14.w,
                                  ),
                                  text: '$_priority',
                                ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (_currentDate != null &&
                                  _priority != null &&
                                  _currentTime != null) {
                                context.read<AddTaskCubit>().addTask(
                                  TaskModel(
                                    dateTime: DateTime(
                                      _currentDate!.year,
                                      _currentDate!.month,
                                      _currentDate!.day,
                                      _currentTime!.hour,
                                      _currentTime!.minute,
                                    ),
                                    name: _titleController.text.trim(),
                                    description: _descriptionController.text
                                        .trim(),
                                    priority: _priority!,
                                  ),
                                );
                              } else {
                                showErrorDialog(
                                  context: context,
                                  errorMessage:
                                      _generateValidationErrorMessage(),
                                );
                              }
                            }
                          },
                          child: SvgPicture.asset('assets/icons/send-icon.svg'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state is AddTaskLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: CupertinoActivityIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _generateValidationErrorMessage() {
    final List<String> missingItems = [];

    if (_currentDate == null) {
      missingItems.add('date');
    }
    if (_currentTime == null) {
      missingItems.add('time');
    }
    if (_priority == null) {
      missingItems.add('priority');
    }

    if (missingItems.isEmpty) {
      return 'An unknown validation error occurred.'; // Fallback
    }

    String message;
    if (missingItems.length == 1) {
      message = missingItems.first;
    } else {
      String lastItem = missingItems.removeLast();
      message = '${missingItems.join(', ')} and $lastItem';
    }

    return 'Please select a $message.';
  }

  void showErrorDialog({
    required BuildContext context,
    required String errorMessage,
  }) => showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) =>
        CustomErrorDialog(title: 'Error', description: errorMessage),
  );
}
