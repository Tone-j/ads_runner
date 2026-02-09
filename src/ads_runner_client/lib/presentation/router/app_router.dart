import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/injection_container.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/campaigns/campaign_detail/campaign_detail_cubit.dart';
import '../blocs/campaigns/campaign_form/campaign_form_bloc.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/campaigns/campaigns_list_page.dart';
import '../pages/campaigns/campaign_detail_page.dart';
import '../pages/campaigns/campaign_form_page.dart';
import '../pages/analytics/analytics_page.dart';
import '../pages/screens_management/screens_list_page.dart';
import '../pages/screens_management/screen_detail_page.dart';
import '../pages/screens_management/screens_map_page.dart';
import '../pages/subscriptions/subscriptions_page.dart';
import '../pages/subscriptions/payment_history_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/shell/app_shell.dart';
import 'route_paths.dart';

class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.forgotPassword;

      if (!isAuthenticated && !isAuthRoute) return RoutePaths.login;
      if (isAuthenticated && isAuthRoute) return RoutePaths.dashboard;
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: RoutePaths.register, builder: (context, state) => const RegisterPage()),
      GoRoute(path: RoutePaths.forgotPassword, builder: (context, state) => const ForgotPasswordPage()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: RoutePaths.dashboard, builder: (context, state) => const DashboardPage()),
          GoRoute(path: RoutePaths.campaigns, builder: (context, state) => const CampaignsListPage()),
          GoRoute(
            path: RoutePaths.campaignNew,
            builder: (context, state) => BlocProvider(
              create: (_) => CampaignFormBloc(),
              child: const CampaignFormPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.campaignDetail,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return BlocProvider(
                create: (_) => sl<CampaignDetailCubit>()..loadCampaign(id),
                child: const CampaignDetailPage(),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.campaignEdit,
            builder: (context, state) => BlocProvider(
              create: (_) => CampaignFormBloc(),
              child: const CampaignFormPage(isEditing: true),
            ),
          ),
          GoRoute(path: RoutePaths.analytics, builder: (context, state) => const AnalyticsPage()),
          GoRoute(path: RoutePaths.screens, builder: (context, state) => const ScreensListPage()),
          GoRoute(
            path: RoutePaths.screenDetail,
            builder: (context, state) => ScreenDetailPage(screenId: state.pathParameters['id']!),
          ),
          GoRoute(path: RoutePaths.screensMap, builder: (context, state) => const ScreensMapPage()),
          GoRoute(path: RoutePaths.subscriptions, builder: (context, state) => const SubscriptionsPage()),
          GoRoute(path: RoutePaths.paymentHistory, builder: (context, state) => const PaymentHistoryPage()),
          GoRoute(path: RoutePaths.settings, builder: (context, state) => const SettingsPage()),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}
