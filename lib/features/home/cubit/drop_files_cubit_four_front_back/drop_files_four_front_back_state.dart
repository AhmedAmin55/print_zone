part of 'drop_files_four_front_back_cubit.dart';


@immutable
abstract class DropFilesStateFourFront {}

class DropFilesFourFrontInitial extends DropFilesStateFourFront {}

class DropFilesFourFrontLoading extends DropFilesStateFourFront {}

class DropFilesFourFrontLoaded extends DropFilesStateFourFront {
  final List<PickedFileModel> files;
  final PickedFileModel? selectedFile;

  DropFilesFourFrontLoaded({
    required this.files,
    this.selectedFile,
  });
}

class DropFilesFourFrontError extends DropFilesStateFourFront {
  final String message;

  DropFilesFourFrontError({required this.message});
}
