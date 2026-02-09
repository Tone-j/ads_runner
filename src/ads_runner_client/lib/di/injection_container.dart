import 'package:get_it/get_it.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/campaign_repository.dart';
import '../domain/repositories/analytics_repository.dart';
import '../domain/repositories/screen_repository.dart';
import '../domain/repositories/subscription_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../mock/mock_auth_repository.dart';
import '../mock/mock_campaign_repository.dart';
import '../mock/mock_analytics_repository.dart';
import '../mock/mock_screen_repository.dart';
import '../mock/mock_subscription_repository.dart';
import '../mock/mock_user_repository.dart';
import '../presentation/blocs/auth/auth_bloc.dart';
import '../presentation/blocs/dashboard/dashboard_cubit.dart';
import '../presentation/blocs/campaigns/campaign_list/campaign_list_cubit.dart';
import '../presentation/blocs/campaigns/campaign_detail/campaign_detail_cubit.dart';
import '../presentation/blocs/campaigns/campaign_form/campaign_form_bloc.dart';
import '../presentation/blocs/analytics/analytics_cubit.dart';
import '../presentation/blocs/screens_management/screens_cubit.dart';
import '../presentation/blocs/subscriptions/subscription_cubit.dart';
import '../presentation/blocs/settings/settings_cubit.dart';
import '../presentation/blocs/navigation/navigation_cubit.dart';
import '../presentation/blocs/theme/theme_cubit.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Repositories (mock implementations)
  sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  sl.registerLazySingleton<CampaignRepository>(() => MockCampaignRepository());
  sl.registerLazySingleton<AnalyticsRepository>(() => MockAnalyticsRepository());
  sl.registerLazySingleton<ScreenRepository>(() => MockScreenRepository());
  sl.registerLazySingleton<SubscriptionRepository>(() => MockSubscriptionRepository());
  sl.registerLazySingleton<UserRepository>(() => MockUserRepository());

  // BLoCs & Cubits
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => DashboardCubit(analyticsRepository: sl()));
  sl.registerFactory(() => CampaignListCubit(campaignRepository: sl()));
  sl.registerFactory(() => CampaignDetailCubit(campaignRepository: sl()));
  sl.registerFactory(() => CampaignFormBloc());
  sl.registerFactory(() => AnalyticsCubit(analyticsRepository: sl()));
  sl.registerFactory(() => ScreensCubit(screenRepository: sl()));
  sl.registerFactory(() => SubscriptionCubit(subscriptionRepository: sl()));
  sl.registerFactory(() => SettingsCubit(userRepository: sl()));
  sl.registerLazySingleton(() => NavigationCubit());
  sl.registerLazySingleton(() => ThemeCubit());
}
