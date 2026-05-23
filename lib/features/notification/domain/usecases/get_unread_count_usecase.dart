import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/notification_repository.dart';

class GetUnreadCountUseCase {
  final NotificationRepository repository;
  GetUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getUnreadCount();
  }
}
