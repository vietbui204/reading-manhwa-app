import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/premium/domain/repositories/premium_repository.dart';
import 'premium_event.dart';
import 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final PremiumRepository premiumRepository;

  PremiumBloc({required this.premiumRepository}) : super(PremiumInitial()) {
    on<PremiumLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(PremiumLoadRequested event, Emitter<PremiumState> emit) async {
    emit(PremiumLoading());
    
    final statusResult = await premiumRepository.getPremiumStatus();
    final plansResult = await premiumRepository.getPremiumPlans();

    statusResult.fold(
      (failure) => emit(PremiumError(failure.message)),
      (status) {
        plansResult.fold(
          (failure) => emit(PremiumError(failure.message)),
          (plans) => emit(PremiumLoaded(
            plans: plans,
            isPremium: status['is_premium'] ?? false,
            premiumUntil: status['premium_until'] != null 
                ? DateTime.parse(status['premium_until']) 
                : null,
          )),
        );
      },
    );
  }
}
