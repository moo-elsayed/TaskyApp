import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/utils/functions.dart';
import '../../data/models/task.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    required this.task,
    required this.onChanged,
    this.contentPadding,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.showDescription = false,
    required this.trailing,
  });

  final TaskModel task;
  final Function(bool isCompleted) onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final bool showDescription;
  final Widget trailing;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  late bool _isCompleted = widget.task.isCompleted ?? false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: widget.contentPadding,
      visualDensity: VisualDensity(horizontal: -4.w),
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        activeColor: ColorsManager.color5F33E1,
        onChanged: (value) {
          _isCompleted = value!;
          widget.onChanged(_isCompleted);
          setState(() {});
        },
        value: _isCompleted,
      ),
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(widget.task.name),
      ),
      titleTextStyle: widget.titleTextStyle,
      subtitle: Text(
        widget.showDescription == false
            ? getDateTime(widget.task.dateTime)
            : widget.task.description ?? 'no description',
      ),
      subtitleTextStyle: widget.subtitleTextStyle,
      trailing: widget.trailing,
    );
  }
}
