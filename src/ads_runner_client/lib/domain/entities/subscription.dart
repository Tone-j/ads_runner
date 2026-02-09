import 'package:equatable/equatable.dart';
import '../../core/enums/subscription_tier.dart';

class Subscription extends Equatable {
  final String id;
  final SubscriptionTier tier;
  final String status;
  final DateTime startDate;
  final DateTime renewalDate;
  final double price;
  final List<String> features;

  const Subscription({
    required this.id,
    required this.tier,
    required this.status,
    required this.startDate,
    required this.renewalDate,
    required this.price,
    required this.features,
  });

  @override
  List<Object> get props => [id, tier, status];
}
