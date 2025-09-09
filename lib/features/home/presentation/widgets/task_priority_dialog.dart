import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import 'package:tasky_app/features/home/presentation/widgets/custom_priority_item.dart';

class TaskPriorityDialog extends StatefulWidget {
  const TaskPriorityDialog({
    super.key,
    this.priority,
    required this.width,
    required this.onPrioritySelected,
  });

  final int? priority;
  final double width;
  final Function(int value) onPrioritySelected;

  @override
  State<TaskPriorityDialog> createState() => _TaskPriorityDialogState();
}

class _TaskPriorityDialogState extends State<TaskPriorityDialog> {
  late int selectedPriority = widget.priority ?? 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: ShapeDecoration(
          color: ColorsManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Task Priority',
              style: TextStylesManager.font16color404147Bold,
            ),
            const Divider(color: ColorsManager.color979797),
            Gap(16.h),
            Wrap(
              spacing: 20.w,
              runSpacing: 12.h,
              children: List.generate(10, (index) {
                bool isSelected = selectedPriority == index + 1;
                return CustomPriorityItem(
                  isSelected: isSelected,
                  number: '${index + 1}',
                  onTap: () {
                    if (index + 1 != selectedPriority) {
                      selectedPriority = index + 1;
                      setState(() {});
                    }
                  },
                );
              }),
            ),
            Gap(16.h),
            Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: CustomMaterialButton(
                    onPressed: () => context.pop(),
                    text: 'Cancel',
                    color: ColorsManager.white,
                    textStyle: TextStylesManager.font16color5F33E1Regular,
                    side: const BorderSide(color: ColorsManager.color5F33E1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Expanded(
                  child: CustomMaterialButton(
                    onPressed: () {
                      widget.onPrioritySelected(selectedPriority);
                      context.pop();
                    },
                    text: 'Save',
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
