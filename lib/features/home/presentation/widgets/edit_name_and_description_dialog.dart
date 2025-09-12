import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/helpers/vaildator.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/custom_material_button.dart';

class EditNameAndDescriptionDialog extends StatefulWidget {
  const EditNameAndDescriptionDialog({
    super.key,
    required this.onEdit,
    required this.initialName,
    required this.initialDescription,
  });

  final Function({required String name, required String description}) onEdit;
  final String initialName;
  final String initialDescription;

  @override
  State<EditNameAndDescriptionDialog> createState() =>
      _EditNameAndDescriptionDialogState();
}

class _EditNameAndDescriptionDialogState
    extends State<EditNameAndDescriptionDialog> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _descriptionController = TextEditingController(
    text: widget.initialDescription,
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: GestureDetector(
        onTap: () => FocusManager
            .instance
            .primaryFocus!
            .unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(10.r),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Task',
                  style: TextStylesManager.font16color404147Bold,
                ),
                Gap(12.h),
                TextFormFieldHelper(
                  controller: _nameController,
                  onValidate: Validator.validateName,
                  action: TextInputAction.next,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  hint: 'enter name...',
                  keyboardType: TextInputType.name,
                ),
                Gap(12.h),
                TextFormFieldHelper(
                  controller: _descriptionController,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  hint: 'enter description...',
                  keyboardType: TextInputType.name,
                  action: TextInputAction.done,
                ),
                Gap(20.h),
                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: CustomMaterialButton(
                        onPressed: () => context.pop(),
                        text: 'Cancel',
                        color: ColorsManager.white,
                        textStyle: TextStylesManager.font16color5F33E1Regular,
                        side: const BorderSide(
                          color: ColorsManager.color5F33E1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onEdit(
                              name: _nameController.text.trim(),
                              description: _descriptionController.text.trim(),
                            );
                            context.pop();
                          }
                        },
                        text: 'Save',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
