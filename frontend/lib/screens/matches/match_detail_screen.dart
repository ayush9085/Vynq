import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../utils/vynk_images.dart';

class MatchDetailScreen extends StatefulWidget {
  final MatchItem match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final _api = ApiService();
  List<String> _dynamicIcebreakers = [];
  bool _loadingIcebreakers = true;

  MatchItem get match => widget.match;

  @override
  void initState() {
    super.initState();
    _loadIcebreakers();
  }

  Future<void> _loadIcebreakers() async {
    try {
      final icebreakers = await _api.getIcebreakers(match.matchUserId);
      if (mounted) {
        setState(() {
          _dynamicIcebreakers = icebreakers;
          _loadingIcebreakers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingIcebreakers = false);
    }
  }

  void _showReportDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VynkColors.surface,
        title: const Text('Report User', style: TextStyle(color: VynkColors.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: VynkColors.textPrimary),
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Describe the issue...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final messenger = ScaffoldMessenger.of(context);
                final nav = Navigator.of(ctx);
                try {
                  final msg = await _api.reportUser(
                    reportedUserId: match.matchUserId,
                    reason: controller.text.trim(),
                  );
                  if (mounted) {
                    nav.pop();
                    messenger.clearSnackBars();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) nav.pop();
                }
              }
            },
            child: const Text('Submit', style: TextStyle(color: VynkColors.nope)),
          ),
        ],
      ),
    );
  }

  List<String> _icebreakers() {
    final firstInterest = match.sharedInterests.isNotEmpty
        ? match.sharedInterests.first
        : 'music';
    final secondInterest = match.sharedInterests.length > 1
        ? match.sharedInterests[1]
        : firstInterest;

    return [
      'You both like $firstInterest — what\'s your go-to lately?',
      'What part of being ${match.mbti} do you feel most seen in?',
      'Pick for this weekend: $firstInterest, $secondInterest, or coffee + walk?',
    ];
  }

  List<Map<String, String>> _profilePrompts() {
    final interests = match.sharedInterests;
    final topInterest =
        interests.isNotEmpty ? interests.first : 'new experiences';
    final second =
        interests.length > 1 ? interests[1] : 'deep conversations';

    return [
      {
        'prompt': '☀️ Ideal Sunday',
        'answer': 'A mix of $topInterest, good food, and no rush.',
      },
      {
        'prompt': '🟢 Green Flag',
        'answer': 'Curious listeners who ask thoughtful follow-ups.',
      },
      {
        'prompt': '💫 Perfect First Date',
        'answer': 'Something playful around $second and then a cozy chat.',
      },
    ];
  }

  Map<String, double> _compatibilityBreakdown() {
    final personality = (match.compatibilityScore / 100 * 0.52 + 0.25)
        .clamp(0.0, 1.0);
    final interests =
        ((match.sharedInterests.length / 6) + 0.2).clamp(0.0, 1.0);
    final communication =
        ((match.reasons.length / 4) + 0.25).clamp(0.0, 1.0);
    final timing =
        ((match.compatibilityScore - 50) / 50).clamp(0.0, 1.0);

    return {
      'Personality Fit': personality,
      'Shared Interests': interests,
      'Communication Style': communication,
      'Timing Match': timing,
    };
  }

  List<String> _dateIdeas() {
    final first = match.sharedInterests.isNotEmpty
        ? match.sharedInterests.first
        : 'coffee tasting';
    final second = match.sharedInterests.length > 1
        ? match.sharedInterests[1]
        : 'bookstore browsing';

    return [
      '🌅 Sunset walk + $first challenge',
      '🎲 $second mini-date & personality quiz',
      '☕ Cozy cafe chat around ${match.mbti} vibes',
    ];
  }

  void _copyStarter(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard ✓'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero photo header
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: VynkColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: VynkImages.profilePortrait(match.name),
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: VynkColors.surfaceLight,
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      decoration: const BoxDecoration(
                        gradient: VynkColors.cardGradient,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: VynkColors.primary,
                        size: 64,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.3, 0.7, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  // Name & score overlay
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    match.name,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: VynkColors.accent
                                              .withValues(alpha: 0.8),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          match.mbti,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${match.sharedInterests.length} shared interests',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: VynkColors.heroGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow:
                                    VynkColors.primaryGlow(opacity: 0.3),
                              ),
                              child: Text(
                                '${match.compatibilityScore.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push(
                          '/chat/${match.matchUserId}',
                          extra: {'name': match.name, 'mbti': match.mbti},
                        ),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: VynkColors.heroGradient,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow:
                                VynkColors.primaryGlow(opacity: 0.25),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Message',
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
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${match.name} saved to favorites ⭐'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: VynkColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: VynkColors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.bookmark_outline,
                          color: VynkColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: VynkColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          color: VynkColors.textMuted,
                        ),
                      ),
                      color: VynkColors.surface,
                      onSelected: (value) async {
                        if (value == 'report') {
                          _showReportDialog();
                        } else if (value == 'block') {
                          final nav = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          await _api.blockUser(match.matchUserId);
                          if (mounted) {
                            nav.pop();
                            messenger.clearSnackBars();
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('User blocked'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'report',
                          child: Row(
                            children: [
                              Icon(Icons.flag_outlined, color: VynkColors.nope, size: 18),
                              SizedBox(width: 10),
                              Text('Report', style: TextStyle(color: VynkColors.textPrimary)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(Icons.block, color: VynkColors.nope, size: 18),
                              SizedBox(width: 10),
                              Text('Block', style: TextStyle(color: VynkColors.nope)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 28),

                // Why you click
                _sectionTitle('Why You Two Click'),
                const SizedBox(height: 8),
                Text(
                  match.explanation,
                  style: const TextStyle(
                    color: VynkColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                ...match.reasons.asMap().entries.map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: VynkColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  VynkColors.heroGradient
                                      .createShader(bounds),
                              child: const Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  color: VynkColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (200 + entry.key * 100).ms)
                          .slideX(begin: 0.1, end: 0),
                    ),
                const SizedBox(height: 24),

                // Compatibility breakdown
                _sectionTitle('Compatibility Breakdown'),
                const SizedBox(height: 14),
                ..._compatibilityBreakdown().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: VynkColors.textPrimary,
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      VynkColors.heroGradient
                                          .createShader(bounds),
                                  child: Text(
                                    '${(entry.value * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: entry.value),
                                duration: const Duration(
                                  milliseconds: 1200,
                                ),
                                curve: Curves.easeOut,
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    minHeight: 6,
                                    backgroundColor:
                                        VynkColors.surfaceLight,
                                    valueColor:
                                        const AlwaysStoppedAnimation(
                                      VynkColors.primary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 24),

                // Conversation starters (AI-generated)
                Row(
                  children: [
                    Expanded(child: _sectionTitle('AI Conversation Starters')),
                    if (_loadingIcebreakers)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: VynkColors.accentLight,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: VynkColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AI Generated',
                          style: TextStyle(
                            color: VynkColors.accentLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ...(_dynamicIcebreakers.isNotEmpty
                        ? _dynamicIcebreakers
                        : _icebreakers())
                    .map(
                  (starter) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: VynkColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: VynkColors.accent.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: VynkColors.accentLight,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            starter,
                            style: const TextStyle(
                              color: VynkColors.textSecondary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _copyStarter(context, starter),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: VynkColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: VynkColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Profile prompts
                _sectionTitle('Profile Prompts'),
                const SizedBox(height: 10),
                ..._profilePrompts().map(
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
                          entry['prompt']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: VynkColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry['answer']!,
                          style: const TextStyle(
                            color: VynkColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Date ideas
                _sectionTitle('Date Ideas'),
                const SizedBox(height: 10),
                ..._dateIdeas().map(
                  (idea) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          VynkColors.primary.withValues(alpha: 0.06),
                          VynkColors.accent.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: VynkColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      idea,
                      style: const TextStyle(
                        color: VynkColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Shared interests
                _sectionTitle('Shared Interests'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: match.sharedInterests.map((i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: VynkColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: VynkColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: VynkColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            i,
                            style: const TextStyle(
                              color: VynkColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: VynkColors.textPrimary,
      ),
    );
  }
}
