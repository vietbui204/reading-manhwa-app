import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/socket/socket_client.dart';
import 'package:appmanga/features/notification/domain/repositories/notification_repository.dart';
import 'package:appmanga/features/notification/data/models/notification_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  final SocketClient socketClient;
  int _currentPage = 1;

  NotificationBloc({
    required this.repository,
    required this.socketClient,
  }) : super(NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationRefresh>(_onRefresh);
    on<NotificationLoadMore>(_onLoadMore);
    on<NotificationMarkRead>(_onMarkRead);
    on<NotificationMarkAllRead>(_onMarkAllRead);
    on<NotificationReceived>(_onReceived);

    _initSocketListener();
  }

  void _initSocketListener() {
    socketClient.onNotification((data) {
      add(NotificationReceived(data));
    });
  }

  Future<void> _onLoadRequested(NotificationLoadRequested event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    _currentPage = 1;
    final result = await repository.getNotifications(page: _currentPage);
    final unreadResult = await repository.getUnreadCount();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) {
        final unreadCount = unreadResult.getOrElse(() => 0);
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length == 20,
          page: _currentPage,
        ));
      },
    );
  }

  Future<void> _onRefresh(NotificationRefresh event, Emitter<NotificationState> emit) async {
    _currentPage = 1;
    final result = await repository.getNotifications(page: _currentPage);
    final unreadResult = await repository.getUnreadCount();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) {
        final unreadCount = unreadResult.getOrElse(() => 0);
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
          hasMore: notifications.length == 20,
          page: _currentPage,
        ));
      },
    );
  }

  Future<void> _onLoadMore(NotificationLoadMore event, Emitter<NotificationState> emit) async {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await repository.getNotifications(page: _currentPage);
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (notifications) {
        emit(current.copyWith(
          notifications: [...current.notifications, ...notifications],
          hasMore: notifications.length == 20,
          isLoadingMore: false,
          page: _currentPage,
        ));
      },
    );
  }

  Future<void> _onMarkRead(NotificationMarkRead event, Emitter<NotificationState> emit) async {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;

    final result = await repository.markAsRead(event.id);
    result.fold(
      (failure) => null,
      (_) {
        emit(current.copyWith(
          unreadCount: current.unreadCount > 0 ? current.unreadCount - 1 : 0,
        ));
        add(NotificationRefresh());
      },
    );
  }

  Future<void> _onMarkAllRead(NotificationMarkAllRead event, Emitter<NotificationState> emit) async {
    if (state is! NotificationLoaded) return;
    final current = state as NotificationLoaded;

    final result = await repository.markAllAsRead();
    result.fold(
      (failure) => null,
      (_) {
        emit(current.copyWith(unreadCount: 0));
        add(NotificationRefresh());
      },
    );
  }

  void _onReceived(NotificationReceived event, Emitter<NotificationState> emit) {
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      try {
        final newNotif = NotificationModel.fromJson(event.data);
        emit(current.copyWith(
          notifications: [newNotif, ...current.notifications],
          unreadCount: current.unreadCount + 1,
        ));
      } catch (e) {
        // Log error
      }
    }
  }
}
