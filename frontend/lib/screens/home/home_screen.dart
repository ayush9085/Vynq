import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../theme.dart';
import '../../utils/vynk_images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _missions = [
    ('🔥', 'Swipe 10 profiles'),
    ('⭐', 'Super like 1 top pick'),
    ('💬', 'Send your first opener'),
  ];

  static const List<({String title, String subtitle, IconData icon, String emoji})>
      _momentIdeas = [
    (
      title: 'Late Night Talkers',
      subtitle: 'Deep chat and voice notes',
      icon: Icons.nights_stay,
      emoji: '🌙',
    ),
    (
      title: 'Weekend Explorers',
      subtitle: 'Planning date ideas',
      icon: Icons.explore,
      emoji: '🗺️',
    ),
    (
      title: 'Coffee First',
      subtitle: 'Low-pressure, high-chemistry',
      icon: Icons.local_cafe,
      emoji: '☕',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      body: CustomScrollView(
        slivers: [
          // Custom app bar
          SliverAppBar(
            floating: true,
            backgroundColor: VynkColors.background,
            surfaceTintColor: Colors.transparent,
            title: ShaderMask(
              shaderCallback: (bounds) =>
                  VynkColors.heroGradient.createShader(bounds),
              child: const Text(
                'VYNK',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: VynkColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: VynkColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await ApiService().logout();
                  if (context.mounted) context.go('/auth/login');
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: VynkColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: VynkColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero card
                _buildHeroCard(context),
                const SizedBox(height: 20),

                // Stories row
                _buildStoriesRow(),
                const SizedBox(height: 24),

                // Start swiping CTA
                GestureDetector(
                  onTap: () => context.go('/home/matches'),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: VynkColors.heroGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: VynkColors.primaryGlow(opacity: 0.3),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swipe, color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Start Swiping',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),

                // Daily missions
                _buildDailyMissions(),
                const SizedBox(height: 24),

                // Moments section
                const Text(
                  'Moments Happening Now',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: VynkColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _buildMomentsCarousel(),
                const SizedBox(height: 24),

                // Quick actions
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // Vynk Plus banner
                _buildPlusBanner(),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: VynkImages.heroCover(),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: VynkColors.surfaceLight,
              ),
              errorWidget: (context, url, error) => Container(
                decoration: const BoxDecoration(
                  gradient: VynkColors.cardGradient,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: VynkColors.primary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'TONIGHT\'S VIBE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Personality First\nDating',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Swipe cards, super-likes, and deeper compatibility.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStoriesRow() {
    final names = ['Alex', 'Jordan', 'Taylor', 'Sam', 'Robin', 'Morgan'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Who Liked You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: VynkColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: VynkColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3 new',
                style: TextStyle(
                  color: VynkColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: names.length,
            separatorBuilder: (_, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final isNew = index < 3;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isNew ? VynkColors.heroGradient : null,
                      border: isNew
                          ? null
                          : Border.all(
                              color: VynkColors.surfaceLight,
                              width: 2,
                            ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: VynkColors.surfaceLight,
                      backgroundImage: CachedNetworkImageProvider(
                        VynkImages.profileThumb(names[index]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    names[index],
                    style: TextStyle(
                      fontSize: 11,
                      color: isNew
                          ? VynkColors.textPrimary
                          : VynkColors.textMuted,
                      fontWeight:
                          isNew ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildDailyMissions() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: VynkColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Missions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: VynkColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: VynkColors.heroGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '1/3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: 0.35,
              minHeight: 6,
              backgroundColor: VynkColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(VynkColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          ..._missions.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(m.$1, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      m.$2,
                      style: const TextStyle(
                        color: VynkColors.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.circle_outlined,
                    size: 20,
                    color: VynkColors.textMuted.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMomentsCarousel() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _momentIdeas.length,
        separatorBuilder: (_, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _momentIdeas[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 230,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: VynkImages.momentCover(index),
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: VynkColors.surfaceLight,
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      decoration: const BoxDecoration(
                        gradient: VynkColors.cardGradient,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Glass badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          color: Colors.white.withValues(alpha: 0.15),
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        // AI matches card
        GestureDetector(
          onTap: () => context.go('/home/matches'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  VynkColors.primary.withValues(alpha: 0.12),
                  VynkColors.accent.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: VynkColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: VynkColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: VynkColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Curated Matches',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: VynkColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'See compatibility scores & vibe explanations',
                        style: TextStyle(
                          color: VynkColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: VynkColors.textMuted,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 12),
        // Re-run analysis card
        GestureDetector(
          onTap: () => context.go('/onboarding'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: VynkColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: VynkColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: VynkColors.accentLight,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Re-run Personality Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: VynkColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Refresh your MBTI profile',
                        style: TextStyle(
                          color: VynkColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: VynkColors.textMuted,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildPlusBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            VynkColors.accent.withValues(alpha: 0.3),
            VynkColors.primary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: VynkColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          VynkColors.heroGradient.createShader(bounds),
                      child: const Text(
                        'Vynk Plus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.bolt, color: VynkColors.gold, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Unlimited rewinds, advanced filters, and priority visibility.',
                  style: TextStyle(
                    color: VynkColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: VynkColors.heroGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0);
  }
}
