import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_images.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/constant/app_textstyle.dart';

class CustomSearchFeild extends StatelessWidget {
  const CustomSearchFeild({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.07,
      width: width * 0.25,
      child: TextFormField(
        decoration: InputDecoration(
          border: borderDecoration(),
          enabledBorder: borderDecoration(),
          focusedBorder: borderDecoration(),
          fillColor: AppColors.white,
          filled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Image.asset(AppImages.searchIcon, width: 20),
          ),
          hintText: AppTexts.search,
          hintStyle: AppTextsStyle.HarmattanBold45(context).copyWith(
            color: AppColors.black.withOpacity(0.3),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  InputBorder borderDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: AppColors.black.withOpacity(0.26),
        width: 0.5,
      ),
    );
  }
}
