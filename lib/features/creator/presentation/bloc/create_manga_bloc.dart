import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appmanga/features/manga/domain/usecases/create_manga_usecase.dart';
import 'package:appmanga/features/manga/data/datasources/upload_remote_datasource.dart';

abstract class CreateMangaEvent extends Equatable {
  @override List<Object?> get props => [];
}

class CreateMangaSubmitted extends CreateMangaEvent {
  final String title;
  final String? description;
  final XFile? coverFile;
  final String status;
  final List<String> genres;

  CreateMangaSubmitted({
    required this.title,
    this.description,
    this.coverFile,
    this.status = 'ongoing',
    this.genres = const [],
  });
}

abstract class CreateMangaState extends Equatable {
  @override List<Object?> get props => [];
}

class CreateMangaInitial extends CreateMangaState {}
class CreateMangaLoading extends CreateMangaState {}
class CreateMangaSuccess extends CreateMangaState {
  final String mangaId;
  CreateMangaSuccess(this.mangaId);
}
class CreateMangaError extends CreateMangaState {
  final String message;
  CreateMangaError(this.message);
}

class CreateMangaBloc extends Bloc<CreateMangaEvent, CreateMangaState> {
  final CreateMangaUseCase createMangaUseCase;
  final UploadRemoteDataSource uploadDataSource;

  CreateMangaBloc({
    required this.createMangaUseCase,
    required this.uploadDataSource,
  }) : super(CreateMangaInitial()) {
    on<CreateMangaSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(CreateMangaSubmitted event, Emitter<CreateMangaState> emit) async {
    emit(CreateMangaLoading());
    try {
      String? coverUrl;
      if (event.coverFile != null) {
        coverUrl = await uploadDataSource.uploadCover(event.coverFile!);
      }

      final result = await createMangaUseCase(CreateMangaParams(
        title: event.title,
        description: event.description,
        coverUrl: coverUrl,
        status: event.status,
        genres: event.genres,
      ));

      result.fold(
        (failure) => emit(CreateMangaError(failure.message)),
        (manga) => emit(CreateMangaSuccess(manga.id)),
      );
    } catch (e) {
      emit(CreateMangaError('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
