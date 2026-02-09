import '../core/enums/campaign_status.dart';
import '../core/enums/screen_status.dart';
import '../core/enums/subscription_tier.dart';
import '../core/enums/region_type.dart';
import '../core/enums/user_role.dart';
import '../domain/entities/user.dart';
import '../domain/entities/campaign.dart';
import '../domain/entities/campaign_summary.dart';
import '../domain/entities/analytics_data.dart';
import '../domain/entities/screen_device.dart';
import '../domain/entities/subscription.dart';
import '../domain/entities/payment_history.dart';
import '../domain/entities/dashboard_metrics.dart';
import '../domain/entities/media_asset.dart';

class MockData {
  static final User currentUser = User(
    id: 'usr_001',
    email: 'john@acmemedia.com',
    firstName: 'John',
    lastName: 'Mitchell',
    role: UserRole.client,
    companyName: 'Acme Media Group',
    avatarUrl: null,
    createdAt: DateTime(2024, 1, 15),
  );

  static final List<CampaignSummary> campaignSummaries = [
    CampaignSummary(
      id: 'cmp_001', name: 'Summer Beverage Promo', status: CampaignStatus.active,
      impressions: 145230, reach: 42100, startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 3, 31),
      thumbnailUrl: 'https://picsum.photos/seed/cmp001/480/270',
    ),
    CampaignSummary(
      id: 'cmp_002', name: 'TechHub Launch Campaign', status: CampaignStatus.active,
      impressions: 89420, reach: 28500, startDate: DateTime(2026, 1, 15), endDate: DateTime(2026, 4, 15),
      thumbnailUrl: 'https://picsum.photos/seed/cmp002/480/270',
    ),
    CampaignSummary(
      id: 'cmp_003', name: 'Fashion Week Special', status: CampaignStatus.paused,
      impressions: 67800, reach: 19200, startDate: DateTime(2026, 2, 1), endDate: DateTime(2026, 2, 28),
      thumbnailUrl: null,
    ),
    CampaignSummary(
      id: 'cmp_004', name: 'Holiday Season Sale', status: CampaignStatus.completed,
      impressions: 312500, reach: 95000, startDate: DateTime(2025, 11, 1), endDate: DateTime(2025, 12, 31),
      thumbnailUrl: null,
    ),
    CampaignSummary(
      id: 'cmp_005', name: 'New Restaurant Opening', status: CampaignStatus.draft,
      impressions: 0, reach: 0, startDate: DateTime(2026, 3, 1), endDate: DateTime(2026, 5, 31),
      thumbnailUrl: null,
    ),
    CampaignSummary(
      id: 'cmp_006', name: 'Fitness Center Awareness', status: CampaignStatus.active,
      impressions: 52100, reach: 15800, startDate: DateTime(2026, 1, 10), endDate: DateTime(2026, 6, 10),
      thumbnailUrl: 'https://picsum.photos/seed/cmp006/480/270',
    ),
    CampaignSummary(
      id: 'cmp_007', name: 'Auto Dealer Weekend Deals', status: CampaignStatus.completed,
      impressions: 198000, reach: 61000, startDate: DateTime(2025, 10, 1), endDate: DateTime(2025, 12, 15),
      thumbnailUrl: null,
    ),
    CampaignSummary(
      id: 'cmp_008', name: 'Music Festival Promo', status: CampaignStatus.archived,
      impressions: 425000, reach: 130000, startDate: DateTime(2025, 6, 1), endDate: DateTime(2025, 8, 31),
      thumbnailUrl: null,
    ),
  ];

  static Campaign getCampaignDetail(String id) {
    final summary = campaignSummaries.firstWhere((c) => c.id == id, orElse: () => campaignSummaries.first);
    return Campaign(
      id: summary.id,
      name: summary.name,
      description: 'This is a detailed description for the ${summary.name} campaign. It targets multiple regions with engaging visual content designed to maximize passenger engagement and brand recall.',
      status: summary.status,
      mediaAssets: [
        MediaAsset(id: 'ma_001', fileName: 'banner_main.jpg', fileUrl: 'https://picsum.photos/seed/${summary.id}/1920/1080', fileType: 'image/jpeg', fileSize: 2450000, uploadedAt: DateTime(2026, 1, 5), thumbnailUrl: 'https://picsum.photos/seed/${summary.id}/480/270'),
        MediaAsset(id: 'ma_002', fileName: 'promo_video.mp4', fileUrl: 'https://example.com/video.mp4', fileType: 'video/mp4', fileSize: 15000000, uploadedAt: DateTime(2026, 1, 5), thumbnailUrl: 'https://picsum.photos/seed/${summary.id}_vid/1920/1080'),
      ],
      targetRegions: [RegionType.gauteng, RegionType.johannesburg],
      startDate: summary.startDate,
      endDate: summary.endDate,
      budget: 90000,
      impressions: summary.impressions,
      reach: summary.reach,
      thumbnailUrl: summary.thumbnailUrl,
      createdAt: summary.startDate.subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    );
  }

  static List<AnalyticsDataPoint> generateAnalyticsData({int days = 30}) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - 1 - i));
      final baseImpressions = 3000 + (i * 50);
      final variance = (i.hashCode % 500) - 250;
      return AnalyticsDataPoint(
        date: date,
        impressions: baseImpressions + variance,
        reach: ((baseImpressions + variance) * 0.3).toInt(),
        revenue: (baseImpressions + variance) * 0.02,
      );
    });
  }

  static CampaignAnalytics getCampaignAnalytics(String campaignId) {
    final dataPoints = generateAnalyticsData();
    final totalImpressions = dataPoints.fold(0, (sum, dp) => sum + dp.impressions);
    final totalReach = dataPoints.fold(0, (sum, dp) => sum + dp.reach);
    return CampaignAnalytics(
      campaignId: campaignId,
      dataPoints: dataPoints,
      totalImpressions: totalImpressions,
      totalReach: totalReach,
      ctr: 3.2,
      avgDailyImpressions: totalImpressions ~/ dataPoints.length,
    );
  }

  static final List<ScreenDevice> screens = [
    ScreenDevice(id: 'scr_001', name: 'Screen Alpha-1', vehiclePlate: 'GP 123 ABC', latitude: -26.2041, longitude: 28.0473, status: ScreenStatus.online, lastSeen: DateTime.now().subtract(const Duration(minutes: 2)), firmwareVersion: '2.4.1', assignedCampaignIds: ['cmp_001', 'cmp_002']),
    ScreenDevice(id: 'scr_002', name: 'Screen Alpha-2', vehiclePlate: 'GP 456 DEF', latitude: -26.1076, longitude: 28.0567, status: ScreenStatus.online, lastSeen: DateTime.now().subtract(const Duration(minutes: 5)), firmwareVersion: '2.4.1', assignedCampaignIds: ['cmp_001']),
    ScreenDevice(id: 'scr_003', name: 'Screen Beta-1', vehiclePlate: 'GP 789 GHI', latitude: -26.1952, longitude: 28.0338, status: ScreenStatus.offline, lastSeen: DateTime.now().subtract(const Duration(hours: 3)), firmwareVersion: '2.3.8', assignedCampaignIds: ['cmp_003']),
    ScreenDevice(id: 'scr_004', name: 'Screen Beta-2', vehiclePlate: 'GP 012 JKL', latitude: -26.2309, longitude: 28.0497, status: ScreenStatus.error, lastSeen: DateTime.now().subtract(const Duration(hours: 1)), firmwareVersion: '2.4.0', assignedCampaignIds: []),
    ScreenDevice(id: 'scr_005', name: 'Screen Gamma-1', vehiclePlate: 'GP 345 MNO', latitude: -26.1496, longitude: 28.0117, status: ScreenStatus.online, lastSeen: DateTime.now().subtract(const Duration(minutes: 1)), firmwareVersion: '2.4.1', assignedCampaignIds: ['cmp_002', 'cmp_006']),
    ScreenDevice(id: 'scr_006', name: 'Screen Gamma-2', vehiclePlate: 'GP 678 PQR', latitude: -26.2618, longitude: 28.0139, status: ScreenStatus.maintenance, lastSeen: DateTime.now().subtract(const Duration(days: 1)), firmwareVersion: '2.3.5', assignedCampaignIds: []),
    ScreenDevice(id: 'scr_007', name: 'Screen Delta-1', vehiclePlate: 'GP 901 STU', latitude: -26.1867, longitude: 28.0706, status: ScreenStatus.online, lastSeen: DateTime.now(), firmwareVersion: '2.4.1', assignedCampaignIds: ['cmp_001', 'cmp_006']),
    ScreenDevice(id: 'scr_008', name: 'Screen Delta-2', vehiclePlate: 'GP 234 VWX', latitude: -26.2126, longitude: 28.0819, status: ScreenStatus.online, lastSeen: DateTime.now().subtract(const Duration(minutes: 8)), firmwareVersion: '2.4.1', assignedCampaignIds: ['cmp_002']),
  ];

  static final Subscription currentSubscription = Subscription(
    id: 'sub_001',
    tier: SubscriptionTier.professional,
    status: 'active',
    startDate: DateTime(2025, 6, 1),
    renewalDate: DateTime(2026, 6, 1),
    price: 4999,
    features: SubscriptionTier.professional.features,
  );

  static final List<PaymentRecord> paymentHistory = [
    PaymentRecord(id: 'pay_001', date: DateTime(2026, 2, 1), amount: 4999, description: 'Professional Plan - Monthly', status: 'paid'),
    PaymentRecord(id: 'pay_002', date: DateTime(2026, 1, 1), amount: 4999, description: 'Professional Plan - Monthly', status: 'paid'),
    PaymentRecord(id: 'pay_003', date: DateTime(2025, 12, 1), amount: 4999, description: 'Professional Plan - Monthly', status: 'paid'),
    PaymentRecord(id: 'pay_004', date: DateTime(2025, 11, 1), amount: 4999, description: 'Professional Plan - Monthly', status: 'paid'),
    PaymentRecord(id: 'pay_005', date: DateTime(2025, 10, 1), amount: 1799, description: 'Starter Plan - Monthly', status: 'paid'),
    PaymentRecord(id: 'pay_006', date: DateTime(2025, 9, 1), amount: 1799, description: 'Starter Plan - Monthly', status: 'paid'),
  ];

  static DashboardMetrics get dashboardMetrics => DashboardMetrics(
    activeCampaigns: 3,
    totalImpressions: 286750,
    dailyReach: 8400,
    monthlyRevenue: 224100,
    onlineScreens: 5,
    totalScreens: 8,
    impressionsTrend: 12.5,
    reachTrend: 8.3,
    revenueTrend: 15.2,
    recentActivity: [
      ActivityItem(id: 'act_001', description: 'Campaign "Summer Beverage Promo" reached 100K impressions', type: 'milestone', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
      ActivityItem(id: 'act_002', description: 'Screen Beta-2 reported connectivity error', type: 'alert', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
      ActivityItem(id: 'act_003', description: 'New campaign "Fashion Week Special" was paused', type: 'campaign', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
      ActivityItem(id: 'act_004', description: 'Payment of R4,999 processed successfully', type: 'billing', timestamp: DateTime.now().subtract(const Duration(days: 1))),
      ActivityItem(id: 'act_005', description: 'Screen Gamma-2 scheduled for maintenance', type: 'maintenance', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6))),
      ActivityItem(id: 'act_006', description: 'Campaign "TechHub Launch" went live', type: 'campaign', timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ],
  );
}
