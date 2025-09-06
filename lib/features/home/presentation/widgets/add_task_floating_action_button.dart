import 'package:flutter/material.dart';
import '../../../../core/theming/colors_manager.dart';

class AddTaskFloatingActionButton extends StatelessWidget {
  const AddTaskFloatingActionButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 0,
      backgroundColor: ColorsManager.color24252C,
      child: const Icon(Icons.add, color: ColorsManager.color5F33E1),
    );
  }
}
