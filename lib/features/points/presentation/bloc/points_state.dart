import 'package:equatable/equatable.dart';
import 'package:appmanga/features/points/domain/entities/task_entity.dart';
import 'package:appmanga/features/points/domain/entities/point_transaction_entity.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object?> get props => [];
}

class PointsInitial extends PointsState {}

class PointsLoading extends PointsState {}

class PointsLoaded extends PointsState {
  final int balance;
  final List<TaskEntity> dailyTasks;
  final List<TaskEntity> oneTimeTasks;
  final String isClaimingTaskId;

  const PointsLoaded({
    required this.balance,
    required this.dailyTasks,
    required this.oneTimeTasks,
    this.isClaimingTaskId = '',
  });

  PointsLoaded copyWith({
    int? balance,
    List<TaskEntity>? dailyTasks,
    List<TaskEntity>? oneTimeTasks,
    String? isClaimingTaskId,
  }) {
    return PointsLoaded(
      balance: balance ?? this.balance,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      oneTimeTasks: oneTimeTasks ?? this.oneTimeTasks,
      isClaimingTaskId: isClaimingTaskId ?? this.isClaimingTaskId,
    );
  }

  @override
  List<Object?> get props => [balance, dailyTasks, oneTimeTasks, isClaimingTaskId];
}

class PointsError extends PointsState {
  final String message;
  const PointsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PointsHistoryLoaded extends PointsState {
  final List<PointTransactionEntity> transactions;
  final bool hasMore;
  final bool isLoadingMore;

  const PointsHistoryLoaded({
    required this.transactions,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  PointsHistoryLoaded copyWith({
    List<PointTransactionEntity>? transactions,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PointsHistoryLoaded(
      transactions: transactions ?? this.transactions,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [transactions, hasMore, isLoadingMore];
}
