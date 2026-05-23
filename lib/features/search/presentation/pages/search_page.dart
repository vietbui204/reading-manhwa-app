import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/di/injection.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'package:appmanga/features/home/presentation/widgets/manga_card_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (value) {
              context.read<SearchBloc>().add(SearchQueryChanged(value));
            },
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm truyện, tác giả...',
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                context.read<SearchBloc>().add(SearchCleared());
              },
            ),
          ],
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SearchEmpty) {
              return const Center(child: Text('Không tìm thấy kết quả'));
            }
            if (state is SearchError) {
              return Center(child: Text(state.message));
            }
            if (state is SearchLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                ),
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  return MangaCardItem(manga: state.results[index]);
                },
              );
            }
            return const Center(child: Text('Nhập từ khóa để tìm kiếm'));
          },
        ),
      ),
    );
  }
}
