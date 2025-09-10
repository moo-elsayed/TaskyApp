import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/utils/functions.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.onChanged,
    this.contentPadding,
    this.titleTextStyle,
    this.subtitleTextStyle,
    required this.trailing,
    this.showPadding = true,
    required this.isCompleted,
    required this.name,
    this.description,
    this.dateTime,
  });

  final String name;
  final String? description;
  final DateTime? dateTime;
  final Function(bool isCompleted) onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Widget trailing;
  final bool showPadding;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      visualDensity: VisualDensity(horizontal: -4.w),
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        activeColor: ColorsManager.color5F33E1,
        onChanged: (value) {
          onChanged(value ?? false);
        },
        value: isCompleted,
      ),
      title: Padding(
        padding: EdgeInsets.only(bottom: showPadding ? 8.h : 0),
        child: Text(name),
      ),
      titleTextStyle: titleTextStyle,
      subtitle: dateTime != null
          ? Text(getDateTime(dateTime!))
          : description != null && description!.isNotEmpty
          ? Text(description!)
          : null,
      subtitleTextStyle: subtitleTextStyle,
      trailing: trailing,
    );
  }
}
