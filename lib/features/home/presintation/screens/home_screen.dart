import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:print_zone/core/constant/app_colors.dart';
import 'package:print_zone/core/constant/app_texts.dart';
import 'package:print_zone/core/constant/app_textstyle.dart';
import 'package:print_zone/features/home/presintation/widgets/file_properties.dart';
import 'package:print_zone/features/home/presintation/widgets/logo_and_search_row.dart';
import 'package:print_zone/features/home/presintation/widgets/total_price_container.dart';

import '../../../../core/constant/app_images.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';
import '../widgets/custom_search_feild.dart';
import '../widgets/drop_files_section.dart';
import '../widgets/droped_files_section.dart';
import '../widgets/order_menu_widget.dart';
import 'ff.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  LogoAndSearchRow(),
                  BlocBuilder<DropFilesCubit, DropFilesState>(
                    builder: (ctext, state) {
                      if (state is DropFilesLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is DropFilesLoaded) {
                        return DropedFilesSection();
                      } else if (state is DropFilesError) {
                        return Center(child: Text(state.message));
                      } else {
                        return DropFilesSection();
                      }
                    },
                  ),
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
                  OrderMenuWidget(),
                  Expanded(
                    child: FileProperties()
                  ),
                  Divider(),
                  TotalPriceContainer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
