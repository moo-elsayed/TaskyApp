import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/vaildator.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_priority_dialog.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
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
    return GestureDetector(
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
              Text('Add Task', style: TextStylesManager.font20color404147Bold),
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

                      if (pickedDate != null && pickedDate != _currentDate) {
                        _currentDate = pickedDate;
                        setState(() {});
                      }
                    },
                    child: _currentDate == null
                        ? SvgPicture.asset('assets/icons/time-icon.svg')
                        : buildContainer(
                            child: Row(
                              spacing: 5.w,
                              children: [
                                SvgPicture.asset('assets/icons/time-icon.svg'),
                                Text(
                                  '${_currentDate!.day}/${_currentDate!.month}/${_currentDate!.year}',
                                  style: TextStylesManager
                                      .font12color24252CRegular,
                                ),
                              ],
                            ),
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
                        : buildContainer(
                            child: Row(
                              spacing: 5.w,
                              children: [
                                SvgPicture.asset('assets/icons/flag-icon.svg'),
                                Text(
                                  '$_priority',
                                  style: TextStylesManager
                                      .font12color24252CRegular,
                                ),
                              ],
                            ),
                          ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (_currentDate != null && _priority != null) {
                          log('Hi');
                        } else {
                          showErrorDialog(context);
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
    );
  }

  void showErrorDialog(BuildContext context) => showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const CustomErrorDialog(),
  );

  Container buildContainer({required Widget child}) => Container(
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.r),
      border: Border.all(color: ColorsManager.color5F33E1),
    ),
    child: child,
  );
}
