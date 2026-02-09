import '../core/enums/subscription_tier.dart';
import '../domain/entities/subscription.dart';
import '../domain/entities/payment_history.dart';
import '../domain/repositories/subscription_repository.dart';
import 'mock_data.dart';

class MockSubscriptionRepository implements SubscriptionRepository {
  @override
  Future<Subscription> getCurrentSubscription() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.currentSubscription;
  }

  @override
  Future<List<Subscription>> getAvailablePlans() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SubscriptionTier.values.map((tier) => Subscription(
      id: 'plan_${tier.name}',
      tier: tier,
      status: tier == SubscriptionTier.professional ? 'active' : 'available',
      startDate: DateTime.now(),
      renewalDate: DateTime.now().add(const Duration(days: 30)),
      price: tier.monthlyPrice.toDouble(),
      features: tier.features,
    )).toList();
  }

  @override
  Future<Subscription> upgradePlan(SubscriptionTier tier) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Subscription(
      id: 'sub_new',
      tier: tier,
      status: 'active',
      startDate: DateTime.now(),
      renewalDate: DateTime.now().add(const Duration(days: 30)),
      price: tier.monthlyPrice.toDouble(),
      features: tier.features,
    );
  }

  @override
  Future<List<PaymentRecord>> getPaymentHistory({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.paymentHistory;
  }
}
