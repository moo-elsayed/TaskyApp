import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/core/utils/functions.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/task_cubit/task_cubit.dart';
import '../../../../core/theming/colors_manager.dart';

class CustomDropdownList extends StatefulWidget{
  const CustomDropdownList({
    super.key,
    required this.days,
    required this.currentDay,
    required this.onChanged,
  });

  final List<DateTime> days;
  final DateTime currentDay;
  final Function(DateTime? value) onChanged;

  @override
  State<CustomDropdownList> createState() => _CustomDropdownListState();

}

class _CustomDropdownListState extends State<CustomDropdownList> {
  late DateTime _selectedValue = widget.currentDay;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Align(
        alignment: AlignmentGeometry.centerLeft,
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorsManager.white,
            border: Border.all(color: ColorsManager.color6E6A7C),
          ),
          child: DropdownButton<DateTime>(
            style: TextStylesManager.font12color404147Regular,
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12.w),
            icon: SvgPicture.asset('assets/icons/drop_down.svg'),
            isExpanded: true,
            value: _selectedValue,
            menuWidth: 100.w,
            dropdownColor: ColorsManager.white,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(10),
            items: widget.days.map((DateTime option) {
              return DropdownMenuItem<DateTime>(
                value: option,
                child: Text(getDay(option)),
              );
            }).toList(),
            onChanged: (DateTime? value) {
              if (value != null && _selectedValue != value) {
                context.read<TaskCubit>().getTasks(value);
                _selectedValue = value;
                widget.onChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }
}
