import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../cubit/drop_files_cubit/drop_files_cubit.dart';
import '../../data/models/file_model.dart';

class FileProperties extends StatelessWidget {
  const FileProperties({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DropFilesCubit>();
    final file = cubit.selectedFile;

    if (file == null) {
      return Center(
        child: Text(
          "اختر ملف لعرض إعداداته",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          /// ---------------- Print Mode ----------------
          DropdownButtonFormField<PrintMode>(
            value: file.printMode,
            items: PrintMode.values.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(getPrintModeLabel(m)),
              );
            }).toList(),
            onChanged: (value) {
              context.read<DropFilesCubit>().updateFileSettings(
                file,
                printMode: value,
              );
            },
          ),

          SizedBox(height: 20),

          /// ---------------- Color Mode ----------------
          DropdownButtonFormField<ColorMode>(
            value: file.colorMode,
            items: ColorMode.values.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(getColorModeLabel(m)),
              );
            }).toList(),
            onChanged: (value) {
              context.read<DropFilesCubit>().updateFileSettings(
                file,
                colorMode: value,
              );
            },
          ),

          SizedBox(height: 20),

          /// ---------------- Paper Size ----------------
          DropdownButtonFormField<PaperSize>(
            value: file.paperSize,
            items: PaperSize.values.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(m.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              context.read<DropFilesCubit>().updateFileSettings(
                file,
                paperSize: value,
              );
            },
          ),

          SizedBox(height: 20),

          /// ---------------- Orientation ----------------
          DropdownButtonFormField<OrientationMode>(
            value: file.orientation,
            items: OrientationMode.values.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(m == OrientationMode.portrait ? "طولي" : "عرضي"),
              );
            }).toList(),
            onChanged: (value) {
              context.read<DropFilesCubit>().updateFileSettings(
                file,
                orientation: value,
              );
            },
          ),
        ],
      ),
    );
  }
}
/// 🟦 Labels
String getPrintModeLabel(PrintMode mode) {
  switch (mode) {
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

String getColorModeLabel(ColorMode mode) {
  switch (mode) {
    case ColorMode.blackWhite:
      return "أبيض وأسود";
    case ColorMode.colored:
      return "ألوان";
  }
}

String getPaperSizeLabel(PaperSize size) {
  switch (size) {
    case PaperSize.a4:
      return "A4";
    case PaperSize.a3:
      return "A3";
    case PaperSize.letter:
      return "Letter";
  }
}

String getOrientationLabel(OrientationMode mode) {
  switch (mode) {
    case OrientationMode.portrait:
      return "طولي";
    case OrientationMode.landscape:
      return "عرضي";
  }
}
