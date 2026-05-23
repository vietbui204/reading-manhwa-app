import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/notification_repository.dart';

class MarkAllReadUseCase {
  final NotificationRepository repository;
  MarkAllReadUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.markAllAsRead();
  }
}
