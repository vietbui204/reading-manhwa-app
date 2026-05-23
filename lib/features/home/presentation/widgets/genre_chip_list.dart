import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class GenreChipList extends StatelessWidget {
  const GenreChipList({super.key});

  final List<String> genres = const [
    'Tất cả',
    'Action',
    'Romance',
    'Fantasy',
    'Horror',
    'Slice of Life',
    'Isekai',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeLoaded && (previous is! HomeLoaded || previous.selectedGenre != current.selectedGenre),
      builder: (context, state) {
        final selectedGenre = (state is HomeLoaded) ? state.selectedGenre : 'Tất cả';

        return SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final genre = genres[index];
              final isActive = genre == selectedGenre;

              return InkWell(
                onTap: () {
                  context.read<HomeBloc>().add(HomeGenreFilterChanged(genre));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.red : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: isActive
                        ? null
                        : Border.all(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                          ),
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(
                      color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
