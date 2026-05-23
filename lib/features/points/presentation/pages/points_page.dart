import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import '../bloc/points_bloc.dart';
import '../bloc/points_event.dart';
import '../bloc/points_state.dart';
import 'package:appmanga/features/points/domain/entities/task_entity.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PointsBloc, PointsState>(
        builder: (context, state) {
          if (state is PointsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is PointsError) {
            return Center(child: Text(state.message));
          }
          if (state is PointsLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<PointsBloc>().add(PointsRefreshRequested()),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, state.balance),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Nhiệm vụ hàng ngày', state.dailyTasks),
                    _buildTaskList(state.dailyTasks, state.isClaimingTaskId),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Nhiệm vụ một lần', state.oneTimeTasks),
                    _buildTaskList(state.oneTimeTasks, state.isClaimingTaskId),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int balance) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.red, AppColors.redDim],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              const Text('Điểm của bạn', style: TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/points/history'),
                child: const Text('Lịch sử', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            FormatHelper.compactNumber(balance),
            style: GoogleFonts.bebasNeue(fontSize: 56, color: Colors.white, letterSpacing: 2),
          ),
          const Text('điểm tích lũy', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, List<TaskEntity> tasks) {
    final doneCount = tasks.where((t) => t.isDone).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 1)),
              const Spacer(),
              Text('$doneCount/${tasks.length}', style: const TextStyle(color: AppColors.darkText3, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          if (tasks.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: doneCount / tasks.length,
                color: AppColors.red,
                backgroundColor: AppColors.darkBg3,
                minHeight: 4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskEntity> tasks, String claimingId) {
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Không có nhiệm vụ nào', style: TextStyle(color: AppColors.darkText3)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _TaskItem(
        task: tasks[index],
        isLoading: claimingId == tasks[index].id,
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TaskEntity task;
  final bool isLoading;

  const _TaskItem({required this.task, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.isDone ? Colors.transparent : AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: task.isDone ? AppColors.red.withOpacity(0.1) : AppColors.darkBg3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIcon(task.actionType),
              color: task.isDone ? AppColors.red : AppColors.darkText3,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: task.isDone ? AppColors.darkText3 : Colors.white,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.stars, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '+${task.pointReward} điểm',
                      style: TextStyle(fontSize: 12, color: task.isDone ? AppColors.darkText3 : Colors.amber),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (task.isDone)
            const Icon(Icons.check_circle, color: Colors.green, size: 24)
          else if (isLoading)
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.red))
          else
            ElevatedButton(
              onPressed: () => context.read<PointsBloc>().add(TaskCompleted(task.id)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                minimumSize: const Size(60, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Nhận', style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'read_chapter': return Icons.menu_book;
      case 'comment': return Icons.comment;
      case 'follow_manga': return Icons.bookmark_add;
      case 'daily_login': return Icons.login;
      case 'share': return Icons.share;
      case 'follow_user': return Icons.person_add;
      default: return Icons.star;
    }
  }
}
