import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';
import '../../data/models/file_model.dart';
import 'custom_text_form_feild.dart';


class FileProperties extends StatelessWidget {
   FileProperties({super.key});
  final TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DropFilesCubit>();
    final file = cubit.selectedFile;

    // لو مفيش ملف مختار
    if (file == null) {
      return const Center(
        child: Text(
          "اختر ملف من اليسار لعرض إعداداته",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            file.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // **************  نوع الطباعة  **************
          _buildDropDown<PrintMode>(
            context: context,
            title: "نوع الطباعة",
            value: file.printMode,
            items: PrintMode.values,
            labelBuilder: getPrintModeLabel,
            onChanged: (v) {
              cubit.updateFileSettings(file, printMode: v);
            },
          ),

          const SizedBox(height: 15),

          // **************  ألوان / أبيض وأسود  **************
          _buildDropDown<ColorMode>(
            context: context,
            title: "اللون",
            value: file.colorMode,
            items: ColorMode.values,
            labelBuilder: getColorModeLabel,
            onChanged: (v) {
              cubit.updateFileSettings(file, colorMode: v);
            },
          ),

          const SizedBox(height: 15),

          // **************  المقاس  **************
          _buildDropDown<PaperSize>(
            context: context,
            title: "مقاس الورق",
            value: file.paperSize,
            items: PaperSize.values,
            labelBuilder: getPaperSizeLabel,
            onChanged: (v) {
              cubit.updateFileSettings(file, paperSize: v);
            },
          ),

          const SizedBox(height: 15),

          // **************  الاتجاه **************
          _buildDropDown<OrientationMode>(
            context: context,
            title: "الاتجاه",
            value: file.orientation,
            items: OrientationMode.values,
            labelBuilder: getOrientationLabel,
            onChanged: (v) {
              cubit.updateFileSettings(file, orientation: v);
            },
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text("Enter Paper Price for this file: "),
              SizedBox(width: 30,),
              Form(
                  key: formKey,
                  child: CustomTextFormFeild(priceController: priceController)),
            ],
          ),

        ],
      ),
    );
  }

  // ************** Widget خاص بالدروب داون  **************
  Widget _buildDropDown<T>({
    required BuildContext context,
    required String title,
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required Function(T) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 5),
        DropdownButtonFormField2<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.black, width: .8),
            ),
          ),
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }
}

// ************** Label Methods **************

String getPrintModeLabel(PrintMode m) {
  switch (m) {
    case PrintMode.oneSide:
      return "وش واحد";
    case PrintMode.duplex:
      return "وش وضهر";
    case PrintMode.twoFrontBack:
      return "وشين وضهرين";
    case PrintMode.fourFrontBack:
      return "4 وشوش و4 ظهر";
  }
}

String getColorModeLabel(ColorMode m) {
  switch (m) {
    case ColorMode.blackWhite:
      return "أبيض وأسود";
    case ColorMode.colored:
      return "ألوان";
  }
}

String getPaperSizeLabel(PaperSize m) {
  switch (m) {
    case PaperSize.a4:
      return "A4";
    case PaperSize.a3:
      return "A3";
    case PaperSize.letter:
      return "Letter";
  }
}

String getOrientationLabel(OrientationMode m) {
  switch (m) {
    case OrientationMode.portrait:
      return "طولي";
    case OrientationMode.landscape:
      return "عرضي";
  }
}