part of 'drop_files_duplex_cubit.dart';


@immutable
abstract class DropFilesStateDuplex {}

class DropFilesDuplexInitial extends DropFilesStateDuplex {}

class DropFilesDuplexLoading extends DropFilesStateDuplex {}

class DropFilesDuplexLoaded extends DropFilesStateDuplex {
  final List<PickedFileModel> files;
  final PickedFileModel? selectedFile;

  DropFilesDuplexLoaded({
    required this.files,
    this.selectedFile,
  });
}

class DropFilesDuplexError extends DropFilesStateDuplex {
  final String message;

  DropFilesDuplexError({required this.message});
}