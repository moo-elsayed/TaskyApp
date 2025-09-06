import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_priority_dialog.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _currentDate = DateTime.now();
  int priority = 1;

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
                      firstDate: DateTime.now(),
                      initialDate: _currentDate,
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 5),
                      ),
                    );

                    if (pickedDate != null && pickedDate != _currentDate) {
                      _currentDate = pickedDate;
                      setState(() {});
                    }
                  },
                  child: SvgPicture.asset('assets/icons/time-icon.svg'),
                ),
                GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => TaskPriorityDialog(
                        width: MediaQuery.widthOf(context),
                        priority: priority,
                        onPrioritySelected: (value) {
                          priority = value;
                        },
                      ),
                    );
                  },
                  child: SvgPicture.asset('assets/icons/flag-icon.svg'),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/send-icon.svg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
