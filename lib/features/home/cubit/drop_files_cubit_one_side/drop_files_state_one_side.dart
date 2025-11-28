part of 'drop_files_cubit_one_side.dart';


@immutable
abstract class DropFilesStateOneSide {}

class DropFilesOneSideInitial extends DropFilesStateOneSide {}

class DropFilesOneSideLoading extends DropFilesStateOneSide {}

class DropFilesOneSideLoaded extends DropFilesStateOneSide {
  final List<PickedFileModel> files;
  final PickedFileModel? selectedFile;

  DropFilesOneSideLoaded({
    required this.files,
    this.selectedFile,
  });
}

class DropFilesOneSideError extends DropFilesStateOneSide {
  final String message;

  DropFilesOneSideError({required this.message});
}