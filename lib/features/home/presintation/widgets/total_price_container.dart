import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';
import 'custom_text_form_feild.dart';

class TotalPriceContainer extends StatelessWidget {
  TotalPriceContainer({super.key});

  final TextEditingController allPriceController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: formKey,
      child: Container(
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
                      children: [
                        Text("Enter Paper Price: "),
                        SizedBox(width: 30),
                        CustomTextFormFeild(
                          priceController: allPriceController,
                          onChanged: (value) {
                            final price = double.tryParse(value) ?? 0.0;
                            context.read<DropFilesCubit>().setPricePerPage(
                              price,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (state is DropFilesLoaded) ...[
                      Text("${state.files.length} File"),
                    ],
                    if (state is DropFilesLoading) ...[Text("Loading...")],
                    if (state is DropFilesInitial) ...[Text("0 files")],
                    SizedBox(height: 15),
                    Text(
                      "${BlocProvider.of<DropFilesCubit>(context).getFinalPrice()} Page",
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
