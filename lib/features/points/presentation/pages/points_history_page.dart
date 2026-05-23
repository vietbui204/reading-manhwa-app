import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import '../bloc/points_bloc.dart';
import '../bloc/points_event.dart';
import '../bloc/points_state.dart';

class PointsHistoryPage extends StatefulWidget {
  const PointsHistoryPage({super.key});

  @override
  State<PointsHistoryPage> createState() => _PointsHistoryPageState();
}

class _PointsHistoryPageState extends State<PointsHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PointsBloc>().add(PointsHistoryLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử điểm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<PointsBloc, PointsState>(
        builder: (context, state) {
          if (state is PointsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is PointsHistoryLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('Chưa có giao dịch nào', style: TextStyle(color: AppColors.darkText3)));
            }
            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.transactions.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                if (index == state.transactions.length) {
                  return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                }
                final tx = state.transactions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tx.amount > 0 ? Colors.green.withOpacity(0.1) : AppColors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tx.amount > 0 ? Icons.add_circle_outline : Icons.remove_circle_outline,
                      color: tx.amount > 0 ? Colors.green : AppColors.red,
                    ),
                  ),
                  title: Text(
                    _getReasonText(tx.reason),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    FormatHelper.timeAgo(tx.createdAt),
                    style: const TextStyle(fontSize: 12, color: AppColors.darkText3),
                  ),
                  trailing: Text(
                    '${tx.amount > 0 ? "+" : ""}${tx.amount}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tx.amount > 0 ? Colors.green : AppColors.red,
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _getReasonText(String reason) {
    switch (reason) {
      case 'task_reward':
        return 'Hoàn thành nhiệm vụ';
      case 'chapter_unlock':
        return 'Mở khoá chapter';
      case 'admin_grant':
        return 'Admin cộng điểm';
      case 'admin_deduct':
        return 'Admin trừ điểm';
      default:
        return reason;
    }
  }
}
