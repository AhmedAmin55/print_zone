import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_images.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/constant/app_textstyle.dart';

class OrderMenuWidget extends StatelessWidget {
  const OrderMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.black.withOpacity(0.26),
          width: 0.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Image.asset(AppImages.orderIcon, width: width * 0.03),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  AppTexts.orderMenu,
                  style: AppTextsStyle.HarmattanBold45(
                    context,
                  ).copyWith(fontSize: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
