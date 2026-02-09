import 'package:equatable/equatable.dart';
import '../../../domain/entities/subscription.dart';
import '../../../domain/entities/payment_history.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}
class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final Subscription currentPlan;
  final List<Subscription> availablePlans;
  final List<PaymentRecord> paymentHistory;

  const SubscriptionLoaded({required this.currentPlan, required this.availablePlans, required this.paymentHistory});
  @override
  List<Object?> get props => [currentPlan, availablePlans, paymentHistory];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  const SubscriptionError(this.message);
  @override
  List<Object?> get props => [message];
}
