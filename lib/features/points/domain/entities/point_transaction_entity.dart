import 'package:equatable/equatable.dart';

class PointTransactionEntity extends Equatable {
  final String id;
  final int amount; // dương = cộng, âm = trừ
  final String reason; // task_reward/chapter_unlock/admin_grant/admin_deduct
  final DateTime createdAt;

  const PointTransactionEntity({
    required this.id,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, amount, reason, createdAt];
}
