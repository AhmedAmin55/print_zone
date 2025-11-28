part of 'drop_files_two_front_back_cubit.dart';

@immutable
abstract class DropFilesStateTwoFront {}

class DropFilesTwoFrontInitial extends DropFilesStateTwoFront {}

class DropFilesTwoFrontLoading extends DropFilesStateTwoFront {}

class DropFilesTwoFrontLoaded extends DropFilesStateTwoFront {
  final List<PickedFileModel> files;
  final PickedFileModel? selectedFile;

  DropFilesTwoFrontLoaded({
    required this.files,
    this.selectedFile,
  });
}

class DropFilesTwoFrontError extends DropFilesStateTwoFront {
  final String message;

  DropFilesTwoFrontError({required this.message});
}
