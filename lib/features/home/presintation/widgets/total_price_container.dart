import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';

class TotalPriceContainer extends StatelessWidget {
  const TotalPriceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: height * 0.12,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          BlocBuilder<DropFilesCubit, DropFilesState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisSize: .max ,
                    children: [],
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Text("for one page 0.75 .LE",textAlign: TextAlign.right,)),
                  if(state is DropFilesLoaded)...[
                    Text("${state.files.length} File"),
                  ],
                  if(state is DropFilesLoading)...[
                    Text("Loading..."),
                  ],  if(state is DropFilesInitial)...[
                    Text("0 files"),
                  ],
                  SizedBox(height: 15),
                  Text("${BlocProvider.of<DropFilesCubit>(context).getTotalPages()} Page"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
