import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_zone/core/constant/app_colors.dart';

import '../../../../core/constant/app_texts.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../cubit/drop_files_cubit_one_side/drop_files_cubit_one_side.dart';

class DropFilesSection extends StatelessWidget {
  const DropFilesSection({super.key, required this.onTap});
final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        child: Center(
          child: GestureDetector(
           onTap: onTap ,
            child: Container(
              height: height*0.04,
                width: width*0.07,
                decoration:BoxDecoration(
                  color: AppColors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text(AppTexts.AddFiles))),
          ),
        ),
      ),
    );
  }
}
