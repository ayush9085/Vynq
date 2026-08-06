import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../utils/vynk_images.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = ApiService();
  late Future<UserProfile> _future;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    _future = _api.myProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          GestureDetector(
            onTap: () => _showMenuPopup(context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VynkColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.more_vert,
                color: VynkColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: VynkColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: VynkColors.textMuted),
              ),
            );
          }

          final user = snapshot.data!;
          final completion = _completion(user);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    // Photo with gradient ring
                    Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: VynkColors.heroGradient,
                            boxShadow: VynkColors.primaryGlow(opacity: 0.25),
                          ),
                          child: CircleAvatar(
                            radius: 52,
                            backgroundColor: VynkColors.surfaceLight,
                            backgroundImage: CachedNetworkImageProvider(
                              VynkImages.profilePortrait(
                                '${user.firstName} ${user.lastName}',
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 16),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: VynkColors.textPrimary,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    // Verified badge
                    GestureDetector(
                      onTap: () => setState(() => _verified = !_verified),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _verified
                              ? Colors.green.withValues(alpha: 0.15)
                              : VynkColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _verified
                                ? Colors.green.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _verified
                                  ? Icons.verified
                                  : Icons.verified_outlined,
                              color: _verified
                                  ? Colors.green
                                  : VynkColors.textMuted,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _verified ? 'Verified' : 'Verify Now',
                              style: TextStyle(
                                color: _verified
                                    ? Colors.green
                                    : VynkColors.textMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  _StatCard(
                    label: 'MBTI',
                    value: user.mbti ?? '?',
                    icon: Icons.psychology,
                    color: VynkColors.accent,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Confidence',
                    value: user.confidence != null
                        ? '${(user.confidence! * 100).toStringAsFixed(0)}%'
                        : '-',
                    icon: Icons.insights,
                    color: VynkColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Age',
                    value: '${user.age ?? '-'}',
                    icon: Icons.cake,
                    color: VynkColors.superLike,
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 20),

              // Profile completion
              Container(
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
                          'Profile Completion',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: VynkColors.textPrimary,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              VynkColors.heroGradient.createShader(bounds),
                          child: Text(
                            '${(completion * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: completion),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOut,
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            backgroundColor: VynkColors.surfaceLight,
                            valueColor: const AlwaysStoppedAnimation(
                              VynkColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 20),

              // Bio section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      VynkColors.primary.withValues(alpha: 0.08),
                      VynkColors.accent.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: VynkColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bio Snapshot',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: VynkColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _bioRow('Gender', user.gender ?? '-'),
                    const SizedBox(height: 14),
                    const Text(
                      'Interests',
                      style: TextStyle(
                        color: VynkColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.interests.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: VynkColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Text(
                            e,
                            style: const TextStyle(
                              color: VynkColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 20),

              // Profile prompts
              const Text(
                'Profile Prompts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: VynkColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ..._promptEntries(user).map(
                (entry) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VynkColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.$1,
                        style: TextStyle(
                          color: VynkColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.$2,
                        style: const TextStyle(
                          color: VynkColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: VynkColors.surface,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: VynkColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: VynkColors.primary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: VynkColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: VynkColors.heroGradient,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: VynkColors.primaryGlow(opacity: 0.25),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add Photos',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _bioRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: VynkColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            color: VynkColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  double _completion(UserProfile user) {
    var filled = 0;
    const total = 6;
    if (user.firstName.trim().isNotEmpty) filled++;
    if ((user.age ?? 0) > 0) filled++;
    if ((user.gender ?? '').trim().isNotEmpty) filled++;
    if (user.interests.isNotEmpty) filled++;
    if ((user.mbti ?? '').trim().isNotEmpty) filled++;
    if (user.confidence != null) filled++;
    return (filled / total).clamp(0, 1).toDouble();
  }

  void _showMenuPopup(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(300, 60, 16, 0),
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.red),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () => _logout(context),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VynkColors.surface,
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      if (context.mounted) {
        context.go('/auth/login');
      }
    }
  }

  List<(String, String)> _promptEntries(UserProfile user) {
    final first = user.interests.isNotEmpty
        ? user.interests.first
        : 'new cafes';
    final second = user.interests.length > 1
        ? user.interests[1]
        : 'deep conversations';

    return [
      (
        '💕 My ideal first date',
        'A relaxed plan with $first and good conversation.',
      ),
      (
        '✨ I will instantly vibe with',
        'Someone kind, playful, and curious about $second.',
      ),
      (
        '🌙 Current life mood',
        'Building a meaningful connection, one honest chat at a time.',
      ),
    ];
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: VynkColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: VynkColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
