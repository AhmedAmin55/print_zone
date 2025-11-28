import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/constant/app_textstyle.dart';
import 'custom_search_feild.dart';

class LogoAndSearchRow extends StatelessWidget {
  const LogoAndSearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    return   Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.black.withOpacity(0.26),
          width: 0.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AppTexts.print,
                  style: AppTextsStyle.HarmattanBold45(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    AppTexts.zone,
                    style: AppTextsStyle.HarmattanBold45(
                      context,
                    ).copyWith(fontSize: 25, height: 0.1),
                  ),
                ),
              ],
            ),
            Spacer(),
           // CustomSearchFeild(),
          ],
        ),
      ),
    );
  }
}
