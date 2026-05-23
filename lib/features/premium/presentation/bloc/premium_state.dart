import 'package:equatable/equatable.dart';
import 'package:appmanga/features/premium/domain/entities/premium_plan_entity.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object?> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumLoading extends PremiumState {}

class PremiumLoaded extends PremiumState {
  final List<PremiumPlanEntity> plans;
  final bool isPremium;
  final DateTime? premiumUntil;

  const PremiumLoaded({
    required this.plans,
    required this.isPremium,
    this.premiumUntil,
  });

  @override
  List<Object?> get props => [plans, isPremium, premiumUntil];
}

class PremiumError extends PremiumState {
  final String message;
  const PremiumError(this.message);

  @override
  List<Object?> get props => [message];
}
