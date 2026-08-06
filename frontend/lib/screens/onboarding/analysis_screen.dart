import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../theme.dart';

class AnalysisScreen extends StatefulWidget {
  final MbtiResult result;

  const AnalysisScreen({super.key, required this.result});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;

  // Fake AI analysis phase
  bool _analyzing = true;
  int _analysisPhase = 0;
  double _analysisProgress = 0;
  Timer? _phaseTimer;
  Timer? _progressTimer;

  static const _analysisSteps = [
    ('Tokenizing your responses...', Icons.text_fields),
    ('Running NLP keyword extraction...', Icons.psychology),
    ('Mapping E/I axis — social energy patterns...', Icons.group),
    ('Mapping S/N axis — information processing...', Icons.lightbulb),
    ('Mapping T/F axis — decision-making style...', Icons.balance),
    ('Mapping J/P axis — lifestyle preferences...', Icons.calendar_today),
    ('Computing confidence scores...', Icons.insights),
    ('Generating personality profile...', Icons.auto_awesome),
  ];

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _startFakeAnalysis();
  }

  @override
  void dispose() {
    _ringController.dispose();
    _phaseTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startFakeAnalysis() {
    // Progress bar moves smoothly
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final target = (_analysisPhase + 1) / _analysisSteps.length;
      setState(() {
        _analysisProgress += (target - _analysisProgress) * 0.08;
        if (_analysisProgress > 0.99) _analysisProgress = 1.0;
      });
    });

    // Cycle through phases
    _phaseTimer =
        Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_analysisPhase < _analysisSteps.length - 1) {
        setState(() => _analysisPhase++);
      } else {
        timer.cancel();
        _progressTimer?.cancel();
        Future<void>.delayed(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _analyzing = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      body: _analyzing ? _buildAnalyzingPhase() : _buildResultPhase(),
    );
  }

  // ──────── PHASE 1: Fake AI Analysis ────────
  Widget _buildAnalyzingPhase() {
    final step = _analysisSteps[_analysisPhase];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spinning brain icon
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _ringController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _ringController.value * 2 * pi,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                VynkColors.primary.withValues(alpha: 0.6),
                                VynkColors.accent.withValues(alpha: 0.6),
                                Colors.transparent,
                                VynkColors.accent.withValues(alpha: 0.6),
                                VynkColors.primary.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: VynkColors.background,
                    ),
                    child: Icon(
                      step.$2,
                      size: 40,
                      color: VynkColors.primary,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback: (bounds) =>
                  VynkColors.heroGradient.createShader(bounds),
              child: const Text(
                'AI Personality Engine',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: _analysisProgress,
                minHeight: 8,
                backgroundColor: VynkColors.surfaceLight,
                valueColor:
                    const AlwaysStoppedAnimation(VynkColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(_analysisProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: VynkColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${widget.result.tokensAnalyzed} tokens',
                  style: TextStyle(
                    color: VynkColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Current step indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(_analysisPhase),
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: VynkColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: VynkColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: VynkColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step.$1,
                        style: TextStyle(
                          color: VynkColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Completed steps log
            ...List.generate(
              _analysisPhase,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 16, color: Colors.green.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Text(
                      _analysisSteps[i].$1,
                      style: TextStyle(
                        color: VynkColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ).reversed.take(4),
          ],
        ),
      ),
    );
  }

  // ──────── PHASE 2: Result Reveal ────────
  Widget _buildResultPhase() {
    final confidence = widget.result.confidence;
    final axes = widget.result.axisScores;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Spinning glow ring behind MBTI type
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _ringController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _ringController.value * 2 * pi,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  VynkColors.primary,
                                  VynkColors.accent,
                                  VynkColors.primary.withValues(alpha: 0.1),
                                  VynkColors.accent,
                                  VynkColors.primary,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: VynkColors.background,
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              VynkColors.heroGradient.createShader(bounds),
                          child: Text(
                            widget.result.mbti,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    curve: Curves.elasticOut,
                    duration: 1200.ms,
                  ),
              const SizedBox(height: 20),

              // Type description
              if (widget.result.typeDescription.isNotEmpty)
                Text(
                  widget.result.typeDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: VynkColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 8),
              Text(
                'AI Personality Analysis Complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: VynkColors.textMuted,
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 20),

              // Analytics row
              Row(
                children: [
                  _AnalyticChip(
                    label: 'Tokens',
                    value: '${widget.result.tokensAnalyzed}',
                    icon: Icons.text_fields,
                  ),
                  const SizedBox(width: 10),
                  _AnalyticChip(
                    label: 'Keywords',
                    value: '${widget.result.totalKeywords}',
                    icon: Icons.key,
                  ),
                  const SizedBox(width: 10),
                  _AnalyticChip(
                    label: 'Confidence',
                    value: '${(confidence * 100).toStringAsFixed(0)}%',
                    icon: Icons.insights,
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),

              // Overall confidence bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VynkColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall Confidence',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: VynkColors.textSecondary,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              VynkColors.heroGradient.createShader(bounds),
                          child: Text(
                            '${(confidence * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
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
                        tween: Tween(begin: 0, end: confidence),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOut,
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 8,
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
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 20),

              // MBTI Axis Scores
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MBTI Axis Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: VynkColors.textPrimary,
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),
              const SizedBox(height: 14),

              ..._buildAxisCards(axes),
              const SizedBox(height: 20),

              // Message
              Text(
                widget.result.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: VynkColors.textMuted,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 1200.ms),
              const SizedBox(height: 28),

              // CTA
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: VynkColors.heroGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: VynkColors.primaryGlow(opacity: 0.3),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.explore, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Discover Matches',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1400.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAxisCards(Map<String, dynamic> axes) {
    final axisLabels = {
      'E/I': ('E', 'I', 'Extraversion', 'Introversion', VynkColors.superLike),
      'N/S': ('N', 'S', 'Intuition', 'Sensing', VynkColors.accentLight),
      'T/F': ('T', 'F', 'Thinking', 'Feeling', VynkColors.primary),
      'J/P': ('J', 'P', 'Judging', 'Perceiving', VynkColors.gold),
    };

    return axisLabels.entries.toList().asMap().entries.map((entry) {
      final i = entry.key;
      final axisKey = entry.value.key;
      final labels = entry.value.value;
      final data = axes[axisKey] as Map<String, dynamic>?;

      final leftPct = data?['${labels.$1}_pct'] as num? ?? 50;
      final rightPct = data?['${labels.$2}_pct'] as num? ?? 50;
      final dominant = data?['dominant'] as String? ?? labels.$1;
      final desc = data?['dominant_description'] as String? ?? '';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VynkColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: labels.$5.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Axis header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: labels.$5.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dominant,
                        style: TextStyle(
                          color: labels.$5,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${labels.$3} vs ${labels.$4}',
                      style: const TextStyle(
                        color: VynkColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Dual progress bar
            Row(
              children: [
                Text(
                  '${labels.$1} ${leftPct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: dominant == labels.$1
                        ? labels.$5
                        : VynkColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '${rightPct.toStringAsFixed(0)}% ${labels.$2}',
                  style: TextStyle(
                    color: dominant == labels.$2
                        ? labels.$5
                        : VynkColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: leftPct / 100),
                duration: Duration(milliseconds: 1000 + i * 200),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: VynkColors.surfaceLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: labels.$5,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                color: VynkColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (800 + i * 150).ms)
          .slideX(begin: 0.1, end: 0);
    }).toList();
  }
}

class _AnalyticChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _AnalyticChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: VynkColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: VynkColors.accentLight, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: VynkColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: VynkColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
