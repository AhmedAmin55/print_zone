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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          OrderMenuWidget(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: height * 0.08,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "وش",
                              textDirection: TextDirection.rtl,
                              style: AppTextsStyle.HarmattanBold45(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<DropFilesCubitOneSide, DropFilesStateOneSide>(
                            builder: (ctext, state) {
                              if (state is DropFilesOneSideLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DropFilesOneSideLoaded) {
                                return Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 2,
                                          childAspectRatio: width < 1400
                                              ? 0.65
                                              : 0.75,
                                        ),
                                    itemCount: state.files.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == state.files.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<
                                                  DropFilesCubitOneSide
                                                >(context)
                                                .pickAndLoadFiles();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final f = state
                                          .files[index]; // ← ✔ اتنقلت فوق قبل الاستخدام

                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<DropFilesCubitOneSide>()
                                              .selectFile(
                                                f,
                                              ); // ← ✔ اختيار الملف
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: width,
                                                height: height * 0.145,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.memory(
                                                    f.thumbnail!,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      f.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          AppTextsStyle.HarmattanBold45(
                                                            context,
                                                          ).copyWith(
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    if (width < 1400) ...[
                                                      Text(
                                                        "pages: ${f.pageCount}",
                                                        style:
                                                            AppTextsStyle.HarmattanBold45(
                                                              context,
                                                            ).copyWith(
                                                              fontSize: 20,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.04,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                  DropFilesCubitOneSide
                                                                >(context)
                                                                .removeFile(f);
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.04,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  5,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: AppColors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (width > 1400) ...[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "pages: ${f.pageCount}",
                                                            style:
                                                                AppTextsStyle.HarmattanBold45(
                                                                  context,
                                                                ).copyWith(
                                                                  fontSize: 20,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          SizedBox(
                                                            height:
                                                                height * 0.04,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                      DropFilesCubitOneSide
                                                                    >(context)
                                                                    .removeFile(
                                                                      f,
                                                                    );
                                                              },
                                                              child: Container(
                                                                height:
                                                                    height *
                                                                    0.04,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state is DropFilesOneSideError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitOneSide>(
                                      context,
                                    ).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
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
                                          final price =
                                              double.tryParse(value) ?? 0.0;
                                          context
                                              .read<DropFilesCubitOneSide>()
                                              .setPricePerPage(price);
                                        },
                                      ),
                                    ],
                                  ),
                                  // ... (باقي النصوص كما هي)
                                  if (state is DropFilesOneSideLoaded) ...[
                                    Row(
                                      children: [
                                        Text("${state.files.length} File"),
                                        SizedBox(width: 30),
                                        Text(
                                          "${BlocProvider.of<DropFilesCubitOneSide>(context).getTotalPages()} Pages",
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (state is DropFilesOneSideLoading) ...[
                                    Text("Loading..."),
                                  ],
                                  if (state is DropFilesOneSideInitial) ...[
                                    Row(
                                      children: [
                                        Text("0 files"),
                                        SizedBox(width: 30),
                                        Text("0 pages"),
                                      ],
                                    ),
                                  ],
                                  Text(
                                    "${BlocProvider.of<DropFilesCubitOneSide>(context).getFinalPrice()} total price",
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.black.withOpacity(0.26),
                  thickness: 2,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: height * 0.08,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "وش و ضهر",
                              textDirection: TextDirection.rtl,
                              style: AppTextsStyle.HarmattanBold45(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<DropFilesCubitDuplex, DropFilesStateDuplex>(
                            builder: (ctext, state) {
                              // ... نفس المنطق
                              if (state is DropFilesDuplexLoading) {
                                // صححت الاسم كان Loaded مرتين
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DropFilesDuplexLoaded) {
                                return Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 2,
                                          childAspectRatio: width < 1400
                                              ? 0.65
                                              : 0.75,
                                        ),
                                    itemCount: state.files.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == state.files.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<
                                                  DropFilesCubitDuplex
                                                >(context)
                                                .pickAndLoadFiles();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final f = state
                                          .files[index]; // ← ✔ اتنقلت فوق قبل الاستخدام

                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<DropFilesCubitDuplex>()
                                              .selectFile(
                                                f,
                                              ); // ← ✔ اختيار الملف
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: width,
                                                height: height * 0.145,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.memory(
                                                    f.thumbnail!,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      f.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          AppTextsStyle.HarmattanBold45(
                                                            context,
                                                          ).copyWith(
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    if (width < 1400) ...[
                                                      Text(
                                                        "pages: ${f.pageCount}",
                                                        style:
                                                            AppTextsStyle.HarmattanBold45(
                                                              context,
                                                            ).copyWith(
                                                              fontSize: 20,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.04,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                  DropFilesCubitDuplex
                                                                >(context)
                                                                .removeFile(f);
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.04,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  5,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: AppColors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (width > 1400) ...[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "pages: ${f.pageCount}",
                                                            style:
                                                                AppTextsStyle.HarmattanBold45(
                                                                  context,
                                                                ).copyWith(
                                                                  fontSize: 20,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          SizedBox(
                                                            height:
                                                                height * 0.04,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                      DropFilesCubitDuplex
                                                                    >(context)
                                                                    .removeFile(
                                                                      f,
                                                                    );
                                                              },
                                                              child: Container(
                                                                height:
                                                                    height *
                                                                    0.04,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state is DropFilesDuplexError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitDuplex>(
                                      context,
                                    ).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          // ... نفس التنسيق
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          height: height * 0.12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              BlocBuilder<
                                DropFilesCubitDuplex,
                                DropFilesStateDuplex
                              >(
                                builder: (context, state) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Enter Paper Price: "),
                                          SizedBox(width: 30),
                                          CustomTextFormFeild(
                                            priceController:
                                                PriceControllerFor2,
                                            onChanged: (value) {
                                              final price =
                                                  double.tryParse(value) ?? 0.0;
                                              context
                                                  .read<DropFilesCubitDuplex>()
                                                  .setPricePerPage(price);
                                            },
                                          ),
                                        ],
                                      ),
                                      if (state is DropFilesDuplexLoaded) ...[
                                        Row(
                                          children: [
                                            Text("${state.files.length} File"),
                                            SizedBox(width: 30),
                                            Text(
                                              "${BlocProvider.of<DropFilesCubitDuplex>(context).getTotalPages()} Pages",
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (state is DropFilesDuplexLoading) ...[
                                        Text("Loading..."),
                                      ],
                                      if (state is DropFilesDuplexInitial) ...[
                                        Row(
                                          children: [
                                            Text("0 files"),
                                            SizedBox(width: 30),

                                            Text("0 pages"),
                                          ],
                                        ),
                                      ],
                                      // ... (باقي النصوص)
                                      Text(
                                        "${BlocProvider.of<DropFilesCubitDuplex>(context).getFinalPrice()} total price",
                                      ),
                                    ],
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.black.withOpacity(0.26),
                  thickness: 2,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: height * 0.08,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "اتنين و اتنين",
                              textDirection: TextDirection.rtl,
                              style: AppTextsStyle.HarmattanBold45(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          // <--- Important
                          child: BlocBuilder<DropFilesCubitTwoFront, DropFilesStateTwoFront>(
                            builder: (ctext, state) {
                              // ... logic
                              if (state is DropFilesTwoFrontLoading) {
                                // صححت الاسم كان Loaded مرتين
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DropFilesTwoFrontLoaded) {
                                return Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 2,
                                          childAspectRatio: width < 1400
                                              ? 0.65
                                              : 0.75,
                                        ),
                                    itemCount: state.files.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == state.files.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<
                                                  DropFilesCubitTwoFront
                                                >(context)
                                                .pickAndLoadFiles();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final f = state
                                          .files[index]; // ← ✔ اتنقلت فوق قبل الاستخدام

                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<DropFilesCubitTwoFront>()
                                              .selectFile(
                                                f,
                                              ); // ← ✔ اختيار الملف
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: width,
                                                height: height * 0.145,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.memory(
                                                    f.thumbnail!,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      f.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          AppTextsStyle.HarmattanBold45(
                                                            context,
                                                          ).copyWith(
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    if (width < 1400) ...[
                                                      Text(
                                                        "pages: ${f.pageCount}",
                                                        style:
                                                            AppTextsStyle.HarmattanBold45(
                                                              context,
                                                            ).copyWith(
                                                              fontSize: 20,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.04,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                  DropFilesCubitTwoFront
                                                                >(context)
                                                                .removeFile(f);
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.04,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  5,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: AppColors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (width > 1400) ...[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "pages: ${f.pageCount}",
                                                            style:
                                                                AppTextsStyle.HarmattanBold45(
                                                                  context,
                                                                ).copyWith(
                                                                  fontSize: 20,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          SizedBox(
                                                            height:
                                                                height * 0.04,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                      DropFilesCubitTwoFront
                                                                    >(context)
                                                                    .removeFile(
                                                                      f,
                                                                    );
                                                              },
                                                              child: Container(
                                                                height:
                                                                    height *
                                                                    0.04,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state is DropFilesTwoFrontError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitTwoFront>(
                                      context,
                                    ).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          height: height * 0.12,
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              BlocBuilder<
                                DropFilesCubitTwoFront,
                                DropFilesStateTwoFront
                              >(
                                builder: (context, state) {
                                  // Content
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Enter Paper Price: "),
                                          SizedBox(width: 30),
                                          CustomTextFormFeild(
                                            priceController:
                                                PriceControllerFor3,
                                            onChanged: (value) {
                                              final price =
                                                  double.tryParse(value) ?? 0.0;
                                              context
                                                  .read<
                                                    DropFilesCubitTwoFront
                                                  >()
                                                  .setPricePerPage(price);
                                            },
                                          ),
                                        ],
                                      ),
                                      if (state is DropFilesTwoFrontLoaded) ...[
                                        Row(
                                          children: [
                                            Text("${state.files.length} File"),
                                            SizedBox(width: 30),
                                            Text(
                                              "${BlocProvider.of<DropFilesCubitTwoFront>(context).getTotalPages()} Pages",
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (state
                                          is DropFilesTwoFrontLoading) ...[
                                        Text("Loading..."),
                                      ],
                                      if (state
                                          is DropFilesTwoFrontInitial) ...[
                                        Row(
                                          children: [
                                            Text("0 files"),
                                            SizedBox(width: 30),

                                            Text("0 pages"),
                                          ],
                                        ),
                                      ],
                                      // ... (باقي النصوص)
                                      Text(
                                        "${BlocProvider.of<DropFilesCubitTwoFront>(context).getFinalPrice()} total price",
                                      ),
                                    ],
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.black.withOpacity(0.26),
                  thickness: 2,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: height * 0.08,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "اربعة و اربعة",
                              textDirection: TextDirection.rtl,
                              style: AppTextsStyle.HarmattanBold45(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          // <--- Important
                          child: BlocBuilder<DropFilesCubitFourFront, DropFilesStateFourFront>(
                            builder: (ctext, state) {
                              if (state is DropFilesFourFrontLoading) {
                                // صححت الاسم كان Loaded مرتين
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DropFilesFourFrontLoaded) {
                                return Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 2,
                                          childAspectRatio: width < 1400
                                              ? 0.65
                                              : 0.75,
                                        ),
                                    itemCount: state.files.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == state.files.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<
                                                  DropFilesCubitFourFront
                                                >(context)
                                                .pickAndLoadFiles();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final f = state
                                          .files[index]; // ← ✔ اتنقلت فوق قبل الاستخدام

                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<DropFilesCubitFourFront>()
                                              .selectFile(
                                                f,
                                              ); // ← ✔ اختيار الملف
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: width,
                                                height: height * 0.145,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.memory(
                                                    f.thumbnail!,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      f.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          AppTextsStyle.HarmattanBold45(
                                                            context,
                                                          ).copyWith(
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    if (width < 1400) ...[
                                                      Text(
                                                        "pages: ${f.pageCount}",
                                                        style:
                                                            AppTextsStyle.HarmattanBold45(
                                                              context,
                                                            ).copyWith(
                                                              fontSize: 20,
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.04,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                  DropFilesCubitFourFront
                                                                >(context)
                                                                .removeFile(f);
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.04,
                                                            padding:
                                                                EdgeInsets.all(
                                                                  5,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: AppColors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (width > 1400) ...[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "pages: ${f.pageCount}",
                                                            style:
                                                                AppTextsStyle.HarmattanBold45(
                                                                  context,
                                                                ).copyWith(
                                                                  fontSize: 20,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          SizedBox(
                                                            height:
                                                                height * 0.04,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                      DropFilesCubitFourFront
                                                                    >(context)
                                                                    .removeFile(
                                                                      f,
                                                                    );
                                                              },
                                                              child: Container(
                                                                height:
                                                                    height *
                                                                    0.04,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                      5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .redAccent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete_outline,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (state is DropFilesFourFrontError) {
                                return Center(child: Text(state.message));
                              } else {
                                return DropFilesSection(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitFourFront>(
                                      context,
                                    ).pickAndLoadFiles();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          height: height * 0.12,
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:
                              BlocBuilder<
                                DropFilesCubitFourFront,
                                DropFilesStateFourFront
                              >(
                                builder: (context, state) {
                                  // Content
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Enter Paper Price: "),
                                          SizedBox(width: 30),
                                          CustomTextFormFeild(
                                            priceController:
                                                PriceControllerFor4,
                                            onChanged: (value) {
                                              final price =
                                                  double.tryParse(value) ?? 0.0;
                                              context
                                                  .read<
                                                    DropFilesCubitFourFront
                                                  >()
                                                  .setPricePerPage(price);
                                            },
                                          ),
                                        ],
                                      ),
                                      if (state
                                          is DropFilesFourFrontLoaded) ...[
                                        Row(
                                          children: [
                                            Text("${state.files.length} File"),
                                            SizedBox(width: 30),
                                            Text(
                                              "${BlocProvider.of<DropFilesCubitFourFront>(context).getTotalPages()} Pages",
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (state
                                          is DropFilesFourFrontLoading) ...[
                                        Text("Loading..."),
                                      ],
                                      if (state
                                          is DropFilesFourFrontInitial) ...[
                                        Row(
                                          children: [
                                            Text("0 files"),
                                            SizedBox(width: 30),

                                            Text("0 pages"),
                                          ],
                                        ),
                                      ],
                                      // ... (باقي النصوص)
                                      Text(
                                        "${BlocProvider.of<DropFilesCubitFourFront>(context).getFinalPrice()} total price",
                                      ),
                                    ],
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<DropFilesCubitOneSide, DropFilesStateOneSide>(
            builder: (context, state) {
              return BlocBuilder<DropFilesCubitDuplex, DropFilesStateDuplex>(
                builder: (context, state) {
                  return BlocBuilder<
                    DropFilesCubitTwoFront,
                    DropFilesStateTwoFront
                  >(
                    builder: (context, state) {
                      return BlocBuilder<
                        DropFilesCubitFourFront,
                        DropFilesStateFourFront
                      >(
                        builder: (context, state) {
                          return Container(
                            margin: EdgeInsets.only(top: 5),
                            height: height * 0.08,
                            width: width,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "Total price = ${context.read<DropFilesCubitOneSide>().getFinalPrice() + context.read<DropFilesCubitDuplex>().getFinalPrice() + context.read<DropFilesCubitTwoFront>().getFinalPrice() + context.read<DropFilesCubitFourFront>().getFinalPrice()} L.E",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
