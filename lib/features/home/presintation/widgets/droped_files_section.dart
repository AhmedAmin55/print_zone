import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_zone/core/constant/app_colors.dart';
import 'package:print_zone/core/constant/app_textstyle.dart';

import '../../cubit/drop_files_cubit_one_side/drop_files_cubit_one_side.dart';
import '../screens/ff.dart';

class DropedFilesSection extends StatelessWidget {
  const DropedFilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var state =
        BlocProvider.of<DropFilesCubitOneSide>(context).state as DropFilesOneSideLoaded;
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio:  width < 1400 ? 0.65 : 0.75,
        ),
        itemCount: state.files.length + 1,
        itemBuilder: (context, index) {
          if (index == state.files.length) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<DropFilesCubitOneSide>(context).pickAndLoadFiles();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Icon(Icons.add, size: 40, color: Colors.white),
                ),
              ),
            );
          }

          final f = state.files[index];   // ← ✔ اتنقلت فوق قبل الاستخدام

          return GestureDetector(
            onTap: () {
              context.read<DropFilesCubitOneSide>().selectFile(f); // ← ✔ اختيار الملف
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: width,
                    height: height * 0.145,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.memory(f.thumbnail!),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          f.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextsStyle.HarmattanBold45(context)
                              .copyWith(fontSize: 20),
                        ),
                        if(width<1400 )...[
                          Text(
                            "pages: ${f.pageCount}",
                            style: AppTextsStyle.HarmattanBold45(context)
                                .copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            height: height*0.04,
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<DropFilesCubitOneSide>(context).removeFile(f);
                              },
                              child: Container(
                                height: height * 0.04,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.white,
                                    size:20 ,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        if(width>1400 )...[
                          Row(
                            children: [
                              Text(
                                "pages: ${f.pageCount}",
                                style: AppTextsStyle.HarmattanBold45(context)
                                    .copyWith(fontSize: 20),
                              ),
                              Spacer(),
                              SizedBox(
                                height: height*0.04,
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<DropFilesCubitOneSide>(context).removeFile(f);
                                  },
                                  child: Container(
                                    height: height * 0.04,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.white,
                                        size:20 ,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
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
  }
}
