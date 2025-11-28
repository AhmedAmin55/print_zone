import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:print_zone/core/constant/app_colors.dart';
import 'package:print_zone/core/constant/app_texts.dart';
import 'package:print_zone/core/constant/app_textstyle.dart';
import 'package:print_zone/features/home/cubit/drop_files_cubit_duplex/drop_files_duplex_cubit.dart';
import 'package:print_zone/features/home/cubit/drop_files_cubit_four_front_back/drop_files_four_front_back_cubit.dart';
import 'package:print_zone/features/home/cubit/drop_files_cubit_two_front_back/drop_files_two_front_back_cubit.dart';
import 'package:print_zone/features/home/presintation/widgets/file_properties.dart';
import 'package:print_zone/features/home/presintation/widgets/logo_and_search_row.dart';
import 'package:print_zone/features/home/presintation/widgets/total_price_container.dart';

import '../../../../core/constant/app_images.dart';
import '../../cubit/drop_files_cubit_one_side/drop_files_cubit_one_side.dart';
import '../widgets/custom_search_feild.dart';
import '../widgets/custom_text_form_feild.dart';
import '../widgets/drop_files_section.dart';
import '../widgets/droped_files_section.dart';
import '../widgets/order_menu_widget.dart';
import 'ff.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController PriceControllerFor1 = TextEditingController();
  final TextEditingController PriceControllerFor2 = TextEditingController();
  final TextEditingController PriceControllerFor3 = TextEditingController();
  final TextEditingController PriceControllerFor4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          OrderMenuWidget(),
          Expanded(
            child: Row(
              children: [
                // ---------------- COLUMN 1 (One Side) ----------------
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Expanded(
                          child: BlocBuilder<DropFilesCubitOneSide, DropFilesStateOneSide>(
                            builder: (ctext, state) {
                              if (state is DropFilesOneSideLoading) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is DropFilesOneSideLoaded) {
                                return DropedFilesSection();
                              } else if (state is DropFilesOneSideError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitOneSide>(context).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          height: height * 0.12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: BlocBuilder<DropFilesCubitOneSide, DropFilesStateOneSide>(
                            builder: (context, state) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Enter Paper Price: "),
                                      SizedBox(width: 30),
                                      // تأكد أن CustomTextFormFeild له width محدد داخله
                                      CustomTextFormFeild(
                                        priceController: PriceControllerFor1,
                                        onChanged: (value) {
                                          final price = double.tryParse(value) ?? 0.0;
                                          context.read<DropFilesCubitOneSide>().setPricePerPage(price);
                                        },
                                      ),
                                    ],
                                  ),
                                  // ... (باقي النصوص كما هي)
                                  if (state is DropFilesOneSideLoaded) ...[
                                    Row(children: [
                                      Text("${state.files.length} File"),
                                      SizedBox(width: 30,),
                                      Text("${BlocProvider.of<DropFilesCubitOneSide>(context).getTotalPages()} Pages")
                                    ],)
                                  ],
                                  if (state is DropFilesOneSideLoading) ...[Text("Loading...")],
                                  if (state is DropFilesOneSideInitial) ...[
                                    Row(
                                      children: [
                                        Text("0 files"),
                                        SizedBox(width: 30,),
                                        Text("0 pages")
                                      ],
                                    )
                                  ],
                                  Text("${BlocProvider.of<DropFilesCubitOneSide>(context).getFinalPrice()} total price"),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                VerticalDivider(color: AppColors.black.withOpacity(0.26), thickness: 2),

                // ---------------- COLUMN 2 (Duplex) ----------------
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        // التغيير هنا: Expanded
                        Expanded(
                          child: BlocBuilder<DropFilesCubitDuplex, DropFilesStateDuplex>(
                            builder: (ctext, state) {
                              // ... نفس المنطق
                              if (state is DropFilesDuplexLoading) { // صححت الاسم كان Loaded مرتين
                                return Center(child: CircularProgressIndicator());
                              } else if (state is DropFilesDuplexLoaded) {
                                return DropedFilesSection();
                              } else if (state is DropFilesDuplexError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitDuplex>(context).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          // ... نفس التنسيق
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          height: height * 0.12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: BlocBuilder<DropFilesCubitDuplex, DropFilesStateDuplex>(
                            builder: (context, state) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Enter Paper Price: "),
                                      SizedBox(width: 30),
                                      CustomTextFormFeild(
                                        priceController: PriceControllerFor2,
                                        onChanged: (value) {
                                          final price = double.tryParse(value) ?? 0.0;
                                          context.read<DropFilesCubitDuplex>().setPricePerPage(price);
                                        },
                                      ),
                                    ],
                                  ),
                                  if (state is DropFilesDuplexLoaded) ...[
                                    Row(children: [
                                      Text("${state.files.length} File"),
                                      SizedBox(width: 30,),
                                      Text("${BlocProvider.of<DropFilesCubitDuplex>(context).getTotalPages()} Pages")
                                    ],)
                                  ],
                                  if (state is DropFilesDuplexLoading) ...[Text("Loading...")],
                                  if (state is DropFilesDuplexInitial) ...[
                                    Row(
                                      children: [
                                        Text("0 files"),
                                        SizedBox(width: 30,),

                                        Text("0 pages")
                                      ],
                                    )
                                  ],
                                  // ... (باقي النصوص)
                                  Text("${BlocProvider.of<DropFilesCubitDuplex>(context).getFinalPrice()} total price"),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                VerticalDivider(color: AppColors.black.withOpacity(0.26), thickness: 2),

                // ---------------- COLUMN 3 & 4 ----------------
                // (يجب تطبيق نفس التغيير: وضع BlocBuilder داخل Expanded وإزالة key: formKey)

                // ... سأختصر الكود هنا، فقط كرر نفس النمط للأعمدة المتبقية (TwoFront و FourFront)

                Expanded(
                    flex: 1,
                    child: Container(
                        color: AppColors.background,
                        child: Column(
                            children: [
                              Expanded( // <--- Important
                                child: BlocBuilder<DropFilesCubitTwoFront, DropFilesStateTwoFront>(
                                  builder: (ctext, state) {
                                    // ... logic
                                    if (state is DropFilesTwoFrontLoading) { // صححت الاسم كان Loaded مرتين
                                      return Center(child: CircularProgressIndicator());
                                    } else if (state is DropFilesTwoFrontLoaded) {
                                      return DropedFilesSection();
                                    } else if (state is DropFilesTwoFrontError) {
                                      return Center(child: Text(state.message));
                                    } else {
                                      return DropFilesSection(
                                        onTap: () {
                                          BlocProvider.of<DropFilesCubitTwoFront>(context).pickAndLoadFiles();
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  height: height * 0.12,
                                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: BlocBuilder<DropFilesCubitTwoFront, DropFilesStateTwoFront>(
                                      builder: (context, state) {
                                        // Content
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Enter Paper Price: "),
                                                SizedBox(width: 30),
                                                CustomTextFormFeild(
                                                  priceController: PriceControllerFor3,
                                                  onChanged: (value) {
                                                    final price = double.tryParse(value) ?? 0.0;
                                                    context.read<DropFilesCubitTwoFront>().setPricePerPage(price);
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (state is DropFilesTwoFrontLoaded) ...[
                                              Row(children: [
                                                Text("${state.files.length} File"),
                                                SizedBox(width: 30,),
                                                Text("${BlocProvider.of<DropFilesCubitTwoFront>(context).getTotalPages()} Pages")
                                              ],)
                                            ],
                                            if (state is DropFilesTwoFrontLoading) ...[Text("Loading...")],
                                            if (state is DropFilesTwoFrontInitial) ...[
                                              Row(
                                                children: [
                                                  Text("0 files"),
                                                  SizedBox(width: 30,),

                                                  Text("0 pages")
                                                ],
                                              )
                                            ],
                                            // ... (باقي النصوص)
                                            Text("${BlocProvider.of<DropFilesCubitTwoFront>(context).getFinalPrice()} total price"),
                                          ],
                                        );
                                      }
                                  )
                              )
                            ]
                        )
                    )
                ),

                VerticalDivider(color: AppColors.black.withOpacity(0.26), thickness: 2),

                Expanded(
                    flex: 1,
                    child: Container(
                        color: AppColors.background,
                        child: Column(
                            children: [
                              Expanded( // <--- Important
                                child: BlocBuilder<DropFilesCubitFourFront, DropFilesStateFourFront>(
                                  builder: (ctext, state) {
                                    if (state is DropFilesFourFrontLoading) { // صححت الاسم كان Loaded مرتين
                                      return Center(child: CircularProgressIndicator());
                                    } else if (state is DropFilesFourFrontLoaded) {
                                      return DropedFilesSection();
                                    } else if (state is DropFilesFourFrontError) {
                                      return Center(child: Text(state.message));
                                    } else {
                                      return DropFilesSection(
                                        onTap: () {
                                          BlocProvider.of<DropFilesCubitFourFront>(context).pickAndLoadFiles();
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  height: height * 0.12,
                                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: BlocBuilder<DropFilesCubitFourFront, DropFilesStateFourFront>(
                                      builder: (context, state) {
                                        // Content
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Enter Paper Price: "),
                                                SizedBox(width: 30),
                                                CustomTextFormFeild(
                                                  priceController: PriceControllerFor4,
                                                  onChanged: (value) {
                                                    final price = double.tryParse(value) ?? 0.0;
                                                    context.read<DropFilesCubitFourFront>().setPricePerPage(price);
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (state is DropFilesFourFrontLoaded) ...[
                                              Row(children: [
                                                Text("${state.files.length} File"),
                                                SizedBox(width: 30,),
                                                Text("${BlocProvider.of<DropFilesCubitFourFront>(context).getTotalPages()} Pages")
                                              ],)
                                            ],
                                            if (state is DropFilesFourFrontLoading) ...[Text("Loading...")],
                                            if (state is DropFilesFourFrontInitial) ...[
                                              Row(
                                                children: [
                                                  Text("0 files"),
                                                  SizedBox(width: 30,),

                                                  Text("0 pages")
                                                ],
                                              )
                                            ],
                                            // ... (باقي النصوص)
                                            Text("${BlocProvider.of<DropFilesCubitFourFront>(context).getFinalPrice()} total price"),
                                          ],
                                        );
                                      }
                                  )
                              )
                            ]
                        )
                    )
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}