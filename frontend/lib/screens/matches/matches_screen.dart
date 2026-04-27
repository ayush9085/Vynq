import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../utils/vynk_images.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiService();
  final List<MatchItem> _allMatches = [];
  final List<MatchItem> _deck = [];
  final List<_SwipeRecord> _history = [];
  Timer? _boostTimer;

  bool _loading = true;
  String? _error;
  String _filter = 'All';
  double _dragX = 0;
  double _dragY = 0;
  bool _boosting = false;
  int _boostSeconds = 0;

  int _liked = 0;
  int _passed = 0;
  int _superLiked = 0;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  @override
  void dispose() {
    _boostTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final matches = await _api.findMatches();
      _allMatches
        ..clear()
        ..addAll(matches);
      _applyFilter();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final filtered = _allMatches.where((m) {
      if (_filter == 'All') return true;
      if (_filter == 'Top Picks') return m.compatibilityScore >= 80;
      if (_filter == 'Nearby') return m.compatibilityScore >= 60;
      if (_filter == 'Elite 90+') return m.compatibilityScore >= 90;
      return true;
    }).toList();

    setState(() {
      _deck
        ..clear()
        ..addAll(filtered);
    });
  }

  void _consumeTop(String action) {
    if (_deck.isEmpty) return;
    final current = _deck.removeAt(0);
    _history.add(_SwipeRecord(match: current, action: action));

    if (action == 'like') _liked++;
    if (action == 'pass') _passed++;
    if (action == 'super') _superLiked++;

    _dragX = 0;
    _dragY = 0;
    setState(() {});

    _showActionSnack(current, action);

    if ((action == 'like' || action == 'super') &&
        current.compatibilityScore >= 84) {
      // Clear snackbar before showing match dialog
      ScaffoldMessenger.of(context).clearSnackBars();
      _showItsAMatchDialog(current, action == 'super');
    }
  }

  void _rewind() {
    if (_history.isEmpty) return;
    final last = _history.removeLast();
    _deck.insert(0, last.match);

    if (last.action == 'like' && _liked > 0) _liked--;
    if (last.action == 'pass' && _passed > 0) _passed--;
    if (last.action == 'super' && _superLiked > 0) _superLiked--;

    setState(() {
      _dragX = 0;
      _dragY = 0;
    });
  }

  void _toggleBoost() {
    if (_boosting) {
      _boostTimer?.cancel();
      setState(() {
        _boosting = false;
        _boostSeconds = 0;
      });
      return;
    }

    setState(() {
      _boosting = true;
      _boostSeconds = 30 * 60;
    });

    _boostTimer?.cancel();
    _boostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_boostSeconds <= 1) {
        timer.cancel();
        setState(() {
          _boosting = false;
          _boostSeconds = 0;
        });
        return;
      }
      setState(() => _boostSeconds--);
    });
  }

  String _boostText() {
    if (!_boosting) return 'Boost';
    final min = (_boostSeconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_boostSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  void _showActionSnack(MatchItem match, String action) {
    final (text, icon, color) = switch (action) {
      'like' => ('Liked ${match.name} 💗', Icons.favorite, VynkColors.like),
      'super' => (
        'Super liked ${match.name} ⭐',
        Icons.star,
        VynkColors.superLike,
      ),
      _ => ('Passed ${match.name}', Icons.close, VynkColors.pass),
    };

    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      action: SnackBarAction(
        label: 'Undo',
        textColor: VynkColors.primary,
        onPressed: () {
          _rewind();
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Automatically dismiss after duration even if user doesn't interact
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
  }

  Future<void> _showItsAMatchDialog(MatchItem match, bool isSuperLike) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: VynkColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: VynkColors.primary.withValues(alpha: 0.3),
              ),
              boxShadow: VynkColors.primaryGlow(opacity: 0.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      VynkColors.heroGradient.createShader(bounds),
                  child: Icon(
                    isSuperLike ? Icons.auto_awesome : Icons.favorite,
                    size: 52,
                    color: Colors.white,
                  ),
                ).animate().scale(
                  begin: const Offset(0.3, 0.3),
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      VynkColors.heroGradient.createShader(bounds),
                  child: const Text(
                    "It's a Match!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 10),
                Text(
                  'You and ${match.name} are a ${match.compatibilityScore.toStringAsFixed(0)}% vibe fit.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: VynkColors.textSecondary),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Keep Swiping'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          context.go('/home/match-detail', extra: match);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: VynkColors.heroGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              'View Match',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _dragLabel() {
    if (_dragY < -90) return 'SUPER LIKE';
    if (_dragX > 90) return 'LIKE';
    if (_dragX < -90) return 'NOPE';
    return null;
  }

  Color? _dragColor() {
    if (_dragY < -90) return VynkColors.superLike;
    if (_dragX > 90) return VynkColors.like;
    if (_dragX < -90) return VynkColors.nope;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          GestureDetector(
            onTap: _toggleBoost,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: _boosting ? VynkColors.heroGradient : null,
                color: _boosting ? null : VynkColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _boosting
                    ? VynkColors.primaryGlow(opacity: 0.2)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt,
                    size: 16,
                    color: _boosting ? Colors.white : VynkColors.gold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _boostText(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _boosting
                          ? Colors.white
                          : VynkColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['All', 'Top Picks', 'Nearby', 'Elite 90+'].map((f) {
                  final selected = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _filter = f);
                        _applyFilter();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: selected ? VynkColors.heroGradient : null,
                          color: selected ? null : VynkColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: selected
                              ? null
                              : Border.all(
                                  color: Colors.white.withValues(alpha: 0.06),
                                ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : VynkColors.textSecondary,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.favorite,
                  label: '$_liked',
                  color: VynkColors.like,
                ),
                const SizedBox(width: 10),
                _StatChip(
                  icon: Icons.close,
                  label: '$_passed',
                  color: VynkColors.pass,
                ),
                const SizedBox(width: 10),
                _StatChip(
                  icon: Icons.star,
                  label: '$_superLiked',
                  color: VynkColors.superLike,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Card stack
          Expanded(
            child: _loading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: VynkColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Finding your matches...',
                          style: TextStyle(color: VynkColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: VynkColors.nope,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: VynkColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _loadMatches,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _deck.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 56,
                          color: VynkColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No more cards',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: VynkColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Refresh or change filters.',
                          style: TextStyle(color: VynkColors.textMuted),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: _loadMatches,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        // Background card
                        if (_deck.length > 1)
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.35,
                              child: Transform.scale(
                                scale: 0.95,
                                child: _SwipeCard(
                                  match: _deck[1],
                                  onOpen: () {},
                                ),
                              ),
                            ),
                          ),
                        // Active card
                        Positioned.fill(
                          child: GestureDetector(
                            onPanUpdate: (d) {
                              setState(() {
                                _dragX += d.delta.dx;
                                _dragY += d.delta.dy;
                              });
                            },
                            onPanEnd: (_) {
                              if (_dragY < -120) {
                                _consumeTop('super');
                              } else if (_dragX > 120) {
                                _consumeTop('like');
                              } else if (_dragX < -120) {
                                _consumeTop('pass');
                              } else {
                                setState(() {
                                  _dragX = 0;
                                  _dragY = 0;
                                });
                              }
                            },
                            child: Transform.translate(
                              offset: Offset(_dragX, _dragY),
                              child: Transform.rotate(
                                angle: _dragX / 1200,
                                child: Stack(
                                  children: [
                                    _SwipeCard(
                                      match: _deck[0],
                                      onOpen: () => context.go(
                                        '/home/match-detail',
                                        extra: _deck[0],
                                      ),
                                    ),
                                    // Drag label overlay
                                    if (_dragLabel() != null)
                                      Positioned(
                                        top: 30,
                                        left: _dragX > 0 ? 24 : null,
                                        right: _dragX <= 0 ? 24 : null,
                                        child: Transform.rotate(
                                          angle: _dragX > 0 ? -0.15 : 0.15,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _dragColor()!.withValues(
                                                alpha: 0.9,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                            child: Text(
                                              _dragLabel()!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                                fontSize: 22,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionCircle(
                  icon: Icons.replay,
                  color: VynkColors.accentLight,
                  size: 48,
                  iconSize: 22,
                  onTap: _rewind,
                ),
                _ActionCircle(
                  icon: Icons.close,
                  color: VynkColors.nope,
                  size: 56,
                  iconSize: 28,
                  onTap: () => _consumeTop('pass'),
                ),
                _ActionCircle(
                  icon: Icons.star,
                  color: VynkColors.superLike,
                  size: 48,
                  iconSize: 22,
                  onTap: () => _consumeTop('super'),
                  gradient: true,
                ),
                _ActionCircle(
                  icon: Icons.favorite,
                  color: VynkColors.like,
                  size: 56,
                  iconSize: 28,
                  onTap: () => _consumeTop('like'),
                  gradient: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeCard extends StatelessWidget {
  final MatchItem match;
  final VoidCallback onOpen;

  const _SwipeCard({required this.match, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full-height photo
              CachedNetworkImage(
                imageUrl: VynkImages.profilePortrait(match.name),
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(
                  color: VynkColors.surfaceLight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: VynkColors.primary,
                    ),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  decoration: const BoxDecoration(
                    gradient: VynkColors.cardGradient,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 72,
                    color: VynkColors.primary,
                  ),
                ),
              ),
              // Gradient overlay from bottom
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              // Info at bottom
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + score
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: VynkColors.heroGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${match.compatibilityScore.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // MBTI + interests
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: VynkColors.accent.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(10),
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
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Interest chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: match.sharedInterests.take(3).map((i) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            i,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (match.explanation.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        match.explanation,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback onTap;
  final bool gradient;

  const _ActionCircle({
    required this.icon,
    required this.color,
    this.size = 56,
    this.iconSize = 26,
    required this.onTap,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient ? null : VynkColors.surface,
          gradient: gradient
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
              : null,
          border: gradient
              ? null
              : Border.all(color: color.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: gradient ? 0.35 : 0.15),
              blurRadius: 16,
              spreadRadius: gradient ? 2 : 0,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: gradient ? Colors.white : color,
          size: iconSize,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeRecord {
  final MatchItem match;
  final String action;

  const _SwipeRecord({required this.match, required this.action});
}
