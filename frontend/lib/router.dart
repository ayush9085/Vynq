import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/api_models.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/likes/likes_screen.dart';
import 'screens/matches/match_detail_screen.dart';
import 'screens/matches/matches_screen.dart';
import 'screens/navigation_shell.dart';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/matches',
              builder: (context, state) => const MatchesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/likes',
              builder: (context, state) => const LikesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/home/match-detail',
      pageBuilder: (context, state) {
        final item = state.extra as MatchItem;
        return CustomTransitionPage(
          key: state.pageKey,
          child: MatchDetailScreen(match: item),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        );
      },
    ),
    // Chat routes
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final extra = state.extra as Map<String, String>?;
        return ChatScreen(
          otherUserId: userId,
          otherUserName: extra?['name'] ?? 'User',
          otherUserMbti: extra?['mbti'] ?? '',
        );
      },
    ),
    // Analytics
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsDashboardScreen(),
    ),
  ],
);
