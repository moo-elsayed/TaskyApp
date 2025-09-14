import 'package:flutter/material.dart';
import '../../../../core/theming/colors_manager.dart';

class AddTaskFloatingActionButton extends StatelessWidget {
  const AddTaskFloatingActionButton({super.key, this.onPressed,required this.opacity});

  final void Function()? onPressed;
  final double opacity;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: 'add_task_button',
        shape: const CircleBorder(),
        elevation: 0,
        backgroundColor: ColorsManager.color5F33E1,
        child: const Icon(Icons.add, color: ColorsManager.white),
      ),
    );
  }
}
