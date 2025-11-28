import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../cubit/drop_files_cubit_one_side/drop_files_cubit_one_side.dart';
import '../../data/models/file_model.dart';
import 'custom_text_form_feild.dart';



class FilePropertiesSection extends StatelessWidget {
  // 1. نستقبل الملف كمتغير
  final PickedFileModel? file;

  // 2. نستقبل دالة التنفيذ التي سنستدعيها عند التغيير
  final Function(PickedFileModel file, PrintMode newMode) onPrintModeChanged;

  const FilePropertiesSection({
    super.key,
    required this.file,
    required this.onPrintModeChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            file!.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // ************** نوع الطباعة  **************
          _buildDropDown<PrintMode>(
            context: context,
            title: "نوع الطباعة",
            value: file!.printMode,
            items: PrintMode.values,
            labelBuilder: getPrintModeLabel,
            onChanged: (newMode) {
              // هنا ننادي الدالة الممررة من الخارج
              onPrintModeChanged(file!, newMode);
            },
          ),
        ],
      ),
    );
  }

  // ************** Widget خاص بالدروب داون **************
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
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField2<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
              child: Text(
                labelBuilder(item),
                textDirection: TextDirection.rtl,
              ),
            ),
          )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          iconStyleData: const IconStyleData(icon: Icon(Icons.arrow_drop_down)),
        ),
      ],
    );
  }
}

// ************** Label Methods **************
String getPrintModeLabel(PrintMode m) {
  switch (m) {
    case PrintMode.oneSide:
      return "وجه واحد";
    case PrintMode.duplex:
      return "وجه و ظهر";
    case PrintMode.twoFrontBack:
      return "2 وجه و 2 ظهر";
    case PrintMode.fourFrontBack:
      return "4 وجه و4 ظهر";
  }
}