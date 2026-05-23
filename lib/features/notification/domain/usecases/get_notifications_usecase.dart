import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call({int page = 1, int limit = 20}) {
    return repository.getNotifications(page: page, limit: limit);
  }
}
