import 'package:appmanga/features/points/presentation/bloc/points_bloc.dart';
import 'package:appmanga/features/points/presentation/bloc/points_event.dart';
import 'package:appmanga/features/points/presentation/pages/points_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/di/injection.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/explore/presentation/pages/explore_page.dart';
import 'package:appmanga/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:appmanga/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:appmanga/features/bookmarks/presentation/bloc/bookmarks_event.dart';
import 'package:appmanga/features/profile/presentation/pages/profile_page.dart';
import 'package:appmanga/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:appmanga/features/profile/presentation/bloc/profile_event.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/genre_chip_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_skeleton_widget.dart';
import '../widgets/home_top_nav.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/manga_horizontal_list.dart';
import '../widgets/rank_item.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final currentUserId = sl<LocalStorage>().getUserId() ?? '';
    
    _pages = [
      const HomeContent(),
      const ExplorePage(),
      BlocProvider(
        create: (context) => sl<PointsBloc>()
          ..add(PointsLoadRequested()),
        child: const PointsPage(),
      ),
      BlocProvider(
        create: (context) => sl<BookmarksBloc>()..add(BookmarksLoadRequested()),
        child: const BookmarksPage(),
      ),
      BlocProvider(
        create: (context) => sl<ProfileBloc>()..add(ProfileLoadRequested(currentUserId)),
        child: ProfilePage(userId: currentUserId),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomeLoadRequested()),
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const HomeSkeletonWidget();
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => context.read<HomeBloc>().add(HomeLoadRequested()),
                      child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(HomeRefreshRequested());
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeTopNav(),
                      const HomeSearchBar(),
                      const SizedBox(height: 16),
                      const GenreChipList(),
                      const SizedBox(height: 20),
                      BannerCarousel(banners: state.data.banners),
                      const SizedBox(height: 24),
                      SectionHeader(title: 'MỚI CẬP NHẬT', onSeeAllTap: () {}),
                      const SizedBox(height: 12),
                      MangaHorizontalList(
                        mangas: state.data.recentlyUpdated,
                        subtitleBuilder: (m) => 'Ch.${m.latestChapter ?? 0} • ${FormatHelper.timeAgo(m.updatedAt)}',
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(title: 'ĐỀ XUẤT CHO BẠN', onSeeAllTap: () {}),
                      const SizedBox(height: 12),
                      MangaHorizontalList(
                        mangas: state.data.recommended,
                        subtitleBuilder: (m) => 'Ch.${m.latestChapter ?? 0} • ${m.genres.isNotEmpty ? m.genres.first : ""}',
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(title: 'BẢNG XẾP HẠNG', onSeeAllTap: () {}),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: state.data.rankings
                              .map((rank) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: RankItem(manga: rank),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
