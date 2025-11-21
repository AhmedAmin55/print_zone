import 'package:flutter/material.dart';
import 'package:print_zone/core/constant/app_colors.dart';
import 'package:print_zone/core/constant/app_texts.dart';
import 'package:print_zone/core/constant/app_textstyle.dart';

import '../../../../core/constant/app_images.dart';
import '../widgets/custom_search_feild.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  Container(
                    height: height * 0.13,
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
                        vertical: 12,
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
                          CustomSearchFeild(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: (){},
                        child: Text(AppTexts.AddFiles),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18.5,
                    ),
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
                  Divider(),
                  Expanded(child: Container(
                    color: Colors.teal,
                  )),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    height: height*0.12,
                    decoration:BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .start,
                          children: [
                            Text("0 items"),
                            SizedBox(height: 15,),
                            Text("Total: 0 LE"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
