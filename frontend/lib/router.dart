import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/matches/match_detail_screen.dart';
import 'screens/matches/matches_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    // Never redirect from splash - let it animate and redirect itself
    if (state.matchedLocation == '/') {
      return null;
    }

    // Check if user is authenticated
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('vynk_auth_token');

    // If not authenticated and trying to access protected routes
    if (token == null &&
        !state.matchedLocation.startsWith('/auth') &&
        state.matchedLocation != '/') {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'matches',
          name: 'matches',
          builder: (context, state) => const MatchesScreen(),
          routes: [
            GoRoute(
              path: ':matchId',
              name: 'match-detail',
              builder: (context, state) {
                final matchId = state.pathParameters['matchId']!;
                return MatchDetailScreen(matchId: matchId);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
