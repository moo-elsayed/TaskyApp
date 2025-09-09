import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorDialog extends StatelessWidget {
  const CustomErrorDialog({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(title, style: GoogleFonts.lato(color: Colors.red)),
      ),
      content: Text(
        description,
        style: GoogleFonts.lato(),
      ),
    );
  }
}
