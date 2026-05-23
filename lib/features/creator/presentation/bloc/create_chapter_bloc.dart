import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/usecases/create_chapter_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_mangas_by_author_usecase.dart';
import 'package:appmanga/features/manga/data/datasources/upload_remote_datasource.dart';

// ── Events ────────────────────────────────────────────
abstract class CreateChapterEvent extends Equatable {
  @override List<Object?> get props => [];
}

class CreateChapterMangasLoaded extends CreateChapterEvent {
  final String authorId;
  CreateChapterMangasLoaded(this.authorId);
}

class CreateChapterMangaSelected extends CreateChapterEvent {
  final MangaEntity manga;
  CreateChapterMangaSelected(this.manga);
}

class CreateChapterPagesAdded extends CreateChapterEvent {
  final List<File> files;
  CreateChapterPagesAdded(this.files);
}

class CreateChapterPageRemoved extends CreateChapterEvent {
  final int index;
  CreateChapterPageRemoved(this.index);
}

class CreateChapterPagesReordered extends CreateChapterEvent {
  final int oldIndex;
  final int newIndex;
  CreateChapterPagesReordered(this.oldIndex, this.newIndex);
}

class CreateChapterSubmitted extends CreateChapterEvent {
  final int chapterNumber;
  final String? title;
  final bool isLocked;
  final int unlockCost;
  final bool isPremiumOnly;
  CreateChapterSubmitted({
    required this.chapterNumber,
    this.title,
    this.isLocked      = false,
    this.unlockCost    = 0,
    this.isPremiumOnly = false,
  });
}

// ── States ────────────────────────────────────────────
abstract class CreateChapterState extends Equatable {
  @override List<Object?> get props => [];
}

class CreateChapterInitial extends CreateChapterState {}

class CreateChapterLoadingMangas extends CreateChapterState {}

class CreateChapterReady extends CreateChapterState {
  final List<MangaEntity> mangas;
  final MangaEntity? selectedManga;
  final List<File> selectedPages;
  final bool isUploading;
  final int uploadedCount;
  final bool isSubmitting;
  final String? errorMessage;

  CreateChapterReady({
    required this.mangas,
    this.selectedManga,
    this.selectedPages  = const [],
    this.isUploading    = false,
    this.uploadedCount  = 0,
    this.isSubmitting   = false,
    this.errorMessage,
  });

  CreateChapterReady copyWith({
    List<MangaEntity>? mangas,
    MangaEntity? selectedManga,
    List<File>? selectedPages,
    bool? isUploading,
    int? uploadedCount,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CreateChapterReady(
      mangas        : mangas         ?? this.mangas,
      selectedManga : selectedManga  ?? this.selectedManga,
      selectedPages : selectedPages  ?? this.selectedPages,
      isUploading   : isUploading    ?? this.isUploading,
      uploadedCount : uploadedCount  ?? this.uploadedCount,
      isSubmitting  : isSubmitting   ?? this.isSubmitting,
      errorMessage  : errorMessage,
    );
  }

  bool get canSubmit =>
      selectedManga != null && selectedPages.isNotEmpty;

  @override
  List<Object?> get props => [
    mangas, selectedManga, selectedPages,
    isUploading, uploadedCount, isSubmitting, errorMessage,
  ];
}

class CreateChapterSuccess extends CreateChapterState {
  final String mangaId;
  CreateChapterSuccess(this.mangaId);
}

class CreateChapterError extends CreateChapterState {
  final String message;
  CreateChapterError(this.message);
}

// ── BLoC ─────────────────────────────────────────────
class CreateChapterBloc
    extends Bloc<CreateChapterEvent, CreateChapterState> {
  final GetMangasByAuthorUseCase getMangasByAuthorUseCase;
  final CreateChapterUseCase createChapterUseCase;
  final UploadRemoteDataSource uploadDataSource;

  CreateChapterBloc({
    required this.getMangasByAuthorUseCase,
    required this.createChapterUseCase,
    required this.uploadDataSource,
  }) : super(CreateChapterInitial()) {
    on<CreateChapterMangasLoaded>(_onMangasLoaded);
    on<CreateChapterMangaSelected>(_onMangaSelected);
    on<CreateChapterPagesAdded>(_onPagesAdded);
    on<CreateChapterPageRemoved>(_onPageRemoved);
    on<CreateChapterPagesReordered>(_onPagesReordered);
    on<CreateChapterSubmitted>(_onSubmitted);
  }

  Future<void> _onMangasLoaded(
      CreateChapterMangasLoaded event,
      Emitter<CreateChapterState> emit,
      ) async {
    emit(CreateChapterLoadingMangas());
    final result = await getMangasByAuthorUseCase(event.authorId);
    result.fold(
          (failure) => emit(CreateChapterError(failure.message)),
          (mangas)  => emit(CreateChapterReady(mangas: mangas)),
    );
  }

  void _onMangaSelected(
      CreateChapterMangaSelected event,
      Emitter<CreateChapterState> emit,
      ) {
    if (state is! CreateChapterReady) return;
    final current = state as CreateChapterReady;
    emit(current.copyWith(selectedManga: event.manga));
  }

  void _onPagesAdded(
      CreateChapterPagesAdded event,
      Emitter<CreateChapterState> emit,
      ) {
    if (state is! CreateChapterReady) return;
    final current = state as CreateChapterReady;
    emit(current.copyWith(
      selectedPages: [...current.selectedPages, ...event.files],
    ));
  }

  void _onPageRemoved(
      CreateChapterPageRemoved event,
      Emitter<CreateChapterState> emit,
      ) {
    if (state is! CreateChapterReady) return;
    final current = state as CreateChapterReady;
    final updated = List<File>.from(current.selectedPages)
      ..removeAt(event.index);
    emit(current.copyWith(selectedPages: updated));
  }

  void _onPagesReordered(
      CreateChapterPagesReordered event,
      Emitter<CreateChapterState> emit,
      ) {
    if (state is! CreateChapterReady) return;
    final current = state as CreateChapterReady;
    final pages = List<File>.from(current.selectedPages);
    final item  = pages.removeAt(event.oldIndex);
    pages.insert(event.newIndex, item);
    emit(current.copyWith(selectedPages: pages));
  }

  Future<void> _onSubmitted(
      CreateChapterSubmitted event,
      Emitter<CreateChapterState> emit,
      ) async {
    if (state is! CreateChapterReady) return;
    final current = state as CreateChapterReady;
    if (!current.canSubmit) return;

    // Bước 1: Upload ảnh lên R2
    emit(current.copyWith(isUploading: true, uploadedCount: 0));
    List<String> imageUrls;
    try {
      imageUrls = await uploadDataSource.uploadPages(
        current.selectedPages,
      );
      emit(current.copyWith(
        isUploading   : false,
        uploadedCount : imageUrls.length,
        isSubmitting  : true,
      ));
    } catch (e) {
      emit(current.copyWith(
        isUploading  : false,
        errorMessage : 'Upload ảnh thất bại: ${e.toString()}',
      ));
      return;
    }

    // Bước 2: Tạo chapter + thêm pages vào DB
    final result = await createChapterUseCase(CreateChapterParams(
      mangaId       : current.selectedManga!.id,
      chapterNumber : event.chapterNumber,
      title         : event.title,
      isLocked      : event.isLocked,
      unlockCost    : event.unlockCost,
      isPremiumOnly : event.isPremiumOnly,
      imageUrls     : imageUrls,
    ));

    result.fold(
          (failure) => emit(current.copyWith(
        isSubmitting : false,
        errorMessage : failure.message,
      )),
          (_) => emit(CreateChapterSuccess(
        current.selectedManga!.id,
      )),
    );
  }
}