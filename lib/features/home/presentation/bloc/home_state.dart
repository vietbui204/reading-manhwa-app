import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/home_data_entity.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeDataEntity data;
  final String selectedGenre;

  HomeLoaded({
    required this.data,
    this.selectedGenre = 'Tất cả',
  });

  @override
  List<Object?> get props => [data, selectedGenre];

  HomeLoaded copyWith({
    HomeDataEntity? data,
    String? selectedGenre,
  }) {
    return HomeLoaded(
      data: data ?? this.data,
      selectedGenre: selectedGenre ?? this.selectedGenre,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
