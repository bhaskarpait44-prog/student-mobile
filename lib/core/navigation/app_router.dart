import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/pin_setup_screen.dart';
import '../../features/auth/presentation/pin_login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

// Import other screens as they are created
import '../../features/attendance/presentation/attendance_screen.dart';
import '../../features/results/presentation/results_screen.dart';
import '../../features/results/presentation/result_detail_screen.dart';
import '../../features/timetable/presentation/timetable_screen.dart';
import '../../features/fees/presentation/fees_screen.dart';
import '../../features/fees/presentation/upi_request_history_screen.dart';
import '../../features/homework/presentation/homework_screen.dart';
import '../../features/homework/presentation/homework_detail_screen.dart';
import '../../features/homework/presentation/notices_screen.dart';
import '../../features/dashboard/presentation/more_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/history_screen.dart';
import '../../features/profile/presentation/achievements_screen.dart';
import '../../features/profile/presentation/change_password_screen.dart';
import '../../features/dashboard/presentation/support_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.isAuthenticated;
      final hasPin = authState.hasPin;
      final isPinAuthenticated = authState.isPinAuthenticated;
      
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuth = state.matchedLocation.startsWith('/auth');
      final isOnPinSetup = state.matchedLocation == '/auth/pin-setup';
      final isOnPinLogin = state.matchedLocation == '/auth/pin-login';

      if (isLoading) return isOnSplash ? null : '/splash';

      if (!isLoggedIn) {
        if (isOnAuth && !isOnPinSetup && !isOnPinLogin) return null;
        return '/auth/login';
      }

      // Logged in
      if (!hasPin) {
        return isOnPinSetup ? null : '/auth/pin-setup';
      }

      if (!isPinAuthenticated) {
        return isOnPinLogin ? null : '/auth/pin-login';
      }

      // Fully authenticated
      if (isOnAuth || isOnSplash) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/pin-setup',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/auth/pin-login',
        builder: (context, state) => const PinLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/results',
            builder: (context, state) => const ResultsScreen(),
            routes: [
              GoRoute(
                path: ':examId',
                builder: (context, state) {
                  final examId = int.parse(state.pathParameters['examId']!);
                  return ResultDetailScreen(examId: examId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/timetable',
            builder: (context, state) => const TimetableScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
      // Secondary screens (not in bottom nav)
      GoRoute(
        path: '/fees',
        builder: (context, state) => const FeesScreen(),
        routes: [
          GoRoute(
            path: 'history',
            builder: (context, state) => const UpiRequestHistoryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/homework',
        builder: (context, state) => const HomeworkScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return HomeworkDetailScreen(homeworkId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticesScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const AcademicHistoryScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
  );
});
