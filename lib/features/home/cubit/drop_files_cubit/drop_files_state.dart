part of 'drop_files_cubit.dart';


@immutable
abstract class DropFilesState {}

class DropFilesInitial extends DropFilesState {}

class DropFilesLoading extends DropFilesState {}

class DropFilesLoaded extends DropFilesState {
  final List<PickedFileModel> files;
  final PickedFileModel? selectedFile;

  DropFilesLoaded({
    required this.files,
    this.selectedFile,
  });
}

class DropFilesError extends DropFilesState {
  final String message;

  DropFilesError({required this.message});
}