import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';


class AppTextsStyle {
//Harmattan
  static TextStyle HarmattanBold45(BuildContext context) {
    return TextStyle(
      color: AppColors.nameColor,
      fontFamily: AppFonts.harmattan,
      fontWeight: FontWeight.w800,
      fontSize: getResponsiveTextsize(context, baseFontsize: 45),
    );
  }

}

  double getResponsiveTextsize(BuildContext context, {
    required double baseFontsize,
  }) {
    double scaleFactor = getScaleFactor(context);
    double responsiveFontsize = scaleFactor * baseFontsize;
    double lowerLimit = baseFontsize * 0.8;
    double upperLimit = baseFontsize * 1.2;

    return responsiveFontsize.clamp(lowerLimit, upperLimit);
  }

  double getScaleFactor(BuildContext context) {
    double width = MediaQuery
        .sizeOf(context)
        .width;
    if (width <= 600) {
      return width / 560;
    }
    if (width > 600 && width <= 1100) {
      return width / 1050;
    } else {
      return width / 1900;
    }
  }

