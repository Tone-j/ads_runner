import '../entities/subscription.dart';
import '../entities/payment_history.dart';
import '../../core/enums/subscription_tier.dart';

abstract class SubscriptionRepository {
  Future<Subscription> getCurrentSubscription();
  Future<List<Subscription>> getAvailablePlans();
  Future<Subscription> upgradePlan(SubscriptionTier tier);
  Future<List<PaymentRecord>> getPaymentHistory({int page = 1});
}
