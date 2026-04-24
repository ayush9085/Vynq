import 'package:go_router/go_router.dart';

import 'models/api_models.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/matches/match_detail_screen.dart';
import 'screens/matches/matches_screen.dart';
import 'screens/onboarding/analysis_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) {
        final result = state.extra as MbtiResult;
        return AnalysisScreen(result: result);
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/home/matches',
      builder: (context, state) => const MatchesScreen(),
    ),
    GoRoute(
      path: '/home/match-detail',
      builder: (context, state) {
        final item = state.extra as MatchItem;
        return MatchDetailScreen(match: item);
      },
    ),
    GoRoute(
      path: '/home/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
