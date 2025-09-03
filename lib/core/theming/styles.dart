import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors_manager.dart';
import 'font_weight_helper.dart';

class TextStylesManager {
  static TextStyle font16WhiteRegular = GoogleFonts.lato(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.white,
  );

  static TextStyle font16color817D8DRegular = GoogleFonts.lato(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.color817D8D,
  );

  static TextStyle font32color404147Bold = GoogleFonts.lato(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.color404147,
  );
}
