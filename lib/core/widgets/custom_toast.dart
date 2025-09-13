import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasky_app/core/theming/styles.dart';

enum ContentType { success, failure, warning }

void showCustomToast({
  required BuildContext context,
  required String message,
  required ContentType contentType,
}) {
  Color bgColor;
  IconData icon;

  switch (contentType) {
    case ContentType.success:
      bgColor = Colors.green;
      icon = Icons.check_circle;
    case ContentType.failure:
      bgColor = Colors.red;
      icon = Icons.error;
    case ContentType.warning:
      bgColor = Colors.orange;
      icon = Icons.warning;
  }

  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: bgColor,
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12.w,
      children: [
        Icon(icon, color: Colors.white, size: 24.r),
        Expanded(
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            style: TextStylesManager.font16WhiteRegular,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
