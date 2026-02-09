enum SubscriptionTier {
  free('Free', 0, ['5 campaigns', '1,000 impressions/mo', 'Basic analytics']),
  starter('Starter', 1799, ['20 campaigns', '10,000 impressions/mo', 'Standard analytics', 'Email support']),
  professional('Professional', 4999, ['Unlimited campaigns', '100,000 impressions/mo', 'Advanced analytics', 'Priority support', 'API access']),
  enterprise('Enterprise', 14999, ['Unlimited everything', 'Custom analytics', 'Dedicated support', 'SLA guarantee', 'White-label options']);

  const SubscriptionTier(this.displayName, this.monthlyPrice, this.features);
  final String displayName;
  final int monthlyPrice;
  final List<String> features;
}
