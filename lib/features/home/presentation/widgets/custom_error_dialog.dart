import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorDialog extends StatelessWidget {
  const CustomErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text('Error', style: GoogleFonts.lato(color: Colors.red)),
      ),
      content: Text(
        'Please select a date and priority',
        style: GoogleFonts.lato(),
      ),
    );
  }
}
