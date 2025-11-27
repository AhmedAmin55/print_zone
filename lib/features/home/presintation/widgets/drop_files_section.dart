import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_zone/core/constant/app_colors.dart';

import '../../../../core/constant/app_texts.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class DropFilesSection extends StatelessWidget {
  const DropFilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        child: Center(
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<DropFilesCubit>(context).pickAndLoadFiles();
            },
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
