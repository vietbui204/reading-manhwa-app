import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/points/domain/usecases/get_tasks_usecase.dart';
import 'package:appmanga/features/points/domain/usecases/complete_task_usecase.dart';
import 'package:appmanga/features/points/domain/usecases/get_point_history_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_point_balance_usecase.dart';
import 'package:appmanga/features/points/presentation/bloc/points_event.dart';
import 'package:appmanga/features/points/presentation/bloc/points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final GetTasksUseCase getTasksUseCase;
  final CompleteTaskUseCase completeTaskUseCase;
  final GetPointBalanceUseCase getPointBalanceUseCase;
  final GetPointHistoryUseCase getPointHistoryUseCase;
  int _historyPage = 1;

  PointsBloc({
    required this.getTasksUseCase,
    required this.completeTaskUseCase,
    required this.getPointBalanceUseCase,
    required this.getPointHistoryUseCase,
  }) : super(PointsInitial()) {
    on<PointsLoadRequested>(_onLoadRequested);
    on<PointsRefreshRequested>(_onRefreshRequested);
    on<TaskCompleted>(_onTaskCompleted);
    on<PointsHistoryLoadRequested>(_onHistoryLoadRequested);
    on<PointsHistoryLoadMore>(_onHistoryLoadMore);
  }

  Future<void> _onLoadRequested(PointsLoadRequested event, Emitter<PointsState> emit) async {
    emit(PointsLoading());
    final balanceResult = await getPointBalanceUseCase();
    final tasksResult = await getTasksUseCase();

    balanceResult.fold(
      (failure) => emit(PointsError(failure.message)),
      (balance) {
        tasksResult.fold(
          (failure) => emit(PointsError(failure.message)),
          (tasks) {
            emit(PointsLoaded(
              balance: balance,
              dailyTasks: tasks.where((t) => t.type == 'daily').toList(),
              oneTimeTasks: tasks.where((t) => t.type == 'one_time').toList(),
            ));
          },
        );
      },
    );
  }

  Future<void> _onRefreshRequested(PointsRefreshRequested event, Emitter<PointsState> emit) async {
    final balanceResult = await getPointBalanceUseCase();
    final tasksResult = await getTasksUseCase();

    balanceResult.fold(
      (failure) => emit(PointsError(failure.message)),
      (balance) {
        tasksResult.fold(
          (failure) => emit(PointsError(failure.message)),
          (tasks) {
            emit(PointsLoaded(
              balance: balance,
              dailyTasks: tasks.where((t) => t.type == 'daily').toList(),
              oneTimeTasks: tasks.where((t) => t.type == 'one_time').toList(),
            ));
          },
        );
      },
    );
  }

  Future<void> _onTaskCompleted(TaskCompleted event, Emitter<PointsState> emit) async {
    if (state is! PointsLoaded) return;
    final current = state as PointsLoaded;
    emit(current.copyWith(isClaimingTaskId: event.taskId));

    final result = await completeTaskUseCase(event.taskId);

    result.fold(
      (failure) => emit(current.copyWith(isClaimingTaskId: '')),
      (data) {
        emit(current.copyWith(
          balance: data.newBalance,
          isClaimingTaskId: '',
          dailyTasks: current.dailyTasks.map((t) =>
            t.id == event.taskId ? t.copyWith(isDone: true, canClaim: false) : t
          ).toList(),
          oneTimeTasks: current.oneTimeTasks.map((t) =>
            t.id == event.taskId ? t.copyWith(isDone: true, canClaim: false) : t
          ).toList(),
        ));
      },
    );
  }

  Future<void> _onHistoryLoadRequested(PointsHistoryLoadRequested event, Emitter<PointsState> emit) async {
    emit(PointsLoading());
    _historyPage = 1;
    final result = await getPointHistoryUseCase(page: _historyPage);
    result.fold(
      (failure) => emit(PointsError(failure.message)),
      (txs) => emit(PointsHistoryLoaded(
        transactions: txs,
        hasMore: txs.length == 20,
      )),
    );
  }

  Future<void> _onHistoryLoadMore(PointsHistoryLoadMore event, Emitter<PointsState> emit) async {
    if (state is! PointsHistoryLoaded) return;
    final current = state as PointsHistoryLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _historyPage++;
    final result = await getPointHistoryUseCase(page: _historyPage);
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (txs) => emit(current.copyWith(
        transactions: [...current.transactions, ...txs],
        hasMore: txs.length == 20,
        isLoadingMore: false,
      )),
    );
  }
}
