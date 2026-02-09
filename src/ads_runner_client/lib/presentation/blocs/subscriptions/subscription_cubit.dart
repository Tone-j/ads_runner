import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionCubit({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository,
        super(SubscriptionInitial());

  Future<void> loadSubscription() async {
    emit(SubscriptionLoading());
    try {
      final current = await _subscriptionRepository.getCurrentSubscription();
      final plans = await _subscriptionRepository.getAvailablePlans();
      final history = await _subscriptionRepository.getPaymentHistory();
      emit(SubscriptionLoaded(currentPlan: current, availablePlans: plans, paymentHistory: history));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
