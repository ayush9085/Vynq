import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _api = ApiService();

  final _age = TextEditingController();
  String _gender = 'Prefer not to say';
  final List<String> _selectedInterests = [];

  // 8 response controllers for each question
  final Map<String, TextEditingController> _responseControllers = {
    '1': TextEditingController(),
    '2': TextEditingController(),
    '3': TextEditingController(),
    '4': TextEditingController(),
    '5': TextEditingController(),
    '6': TextEditingController(),
    '7': TextEditingController(),
    '8': TextEditingController(),
  };

  int _step = 0;
  bool _loading = false;
  String? _error;

  static const _totalSteps = 5;

  static const _interestData = <(String, String)>[
    ('🎵', 'Music'),
    ('✈️', 'Travel'),
    ('💪', 'Fitness'),
    ('🎮', 'Gaming'),
    ('📚', 'Books'),
    ('☕', 'Coffee'),
    ('🎨', 'Art'),
    ('🎬', 'Movies'),
    ('🌿', 'Nature'),
    ('💻', 'Coding'),
    ('🍳', 'Cooking'),
    ('📷', 'Photography'),
    ('🧘', 'Yoga'),
    ('🎭', 'Theater'),
    ('🐶', 'Pets'),
  ];

  @override
  void dispose() {
    _age.dispose();
    for (final c in _responseControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final parsedAge = int.tryParse(_age.text);
    if (parsedAge == null) {
      setState(() => _error = 'Enter a valid age');
      return;
    }
    if (_selectedInterests.isEmpty) {
      setState(() => _error = 'Select at least one interest');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final responses = <String, String>{};
      for (final entry in _responseControllers.entries) {
        if (entry.value.text.trim().isNotEmpty) {
          responses[entry.key] = entry.value.text.trim();
        }
      }

      final MbtiResult result = await _api.completeOnboarding(
        age: parsedAge,
        gender: _gender,
        interests: _selectedInterests,
        responses: responses,
      );
      if (!mounted) return;
      context.go('/analysis', extra: result);
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildStepBasicInfo(),
      _buildStepInterests(),
      _buildStepPersonality1(),
      _buildStepPersonality2(),
      _buildStepPersonality3(),
    ];

    return Scaffold(
      backgroundColor: VynkColors.background,
      appBar: AppBar(
        title: Text('Step ${_step + 1} of $_totalSteps'),
        leading: _step > 0
            ? IconButton(
                onPressed: () => setState(() {
                  _step -= 1;
                  _error = null;
                }),
                icon: const Icon(Icons.arrow_back_ios),
              )
            : null,
      ),
      body: Column(
        children: [
          // Animated progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (_step + 1) / _totalSteps),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: VynkColors.surfaceLight,
                    valueColor:
                        const AlwaysStoppedAnimation(VynkColors.primary),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: VynkColors.nope.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: VynkColors.nope.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _error!,
                  style:
                      const TextStyle(color: VynkColors.nope, fontSize: 13),
                ),
              ),
            ).animate().fadeIn().shake(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: pages[_step],
              ),
            ),
          ),
          // Bottom action
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: _GradientButton(
              onPressed: _loading
                  ? null
                  : _step < _totalSteps - 1
                      ? () {
                          setState(() {
                            _error = null;
                            _step += 1;
                          });
                        }
                      : _submit,
              loading: _loading,
              label: _step < _totalSteps - 1
                  ? 'Continue'
                  : 'Run AI Personality Analysis ✨',
              icon: _step < _totalSteps - 1
                  ? Icons.arrow_forward
                  : Icons.auto_awesome,
            ),
          ),
        ],
      ),
    );
  }

  // — Step 0: Basic Info —
  Widget _buildStepBasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader(
            '👋',
            'Tell us about you',
            'Just the basics — your personality is what matters most.',
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _age,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: VynkColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Age',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _gender,
            dropdownColor: VynkColors.surface,
            style: const TextStyle(color: VynkColors.textPrimary),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
              DropdownMenuItem(
                value: 'Prefer not to say',
                child: Text('Prefer not to say'),
              ),
            ],
            onChanged: (value) =>
                setState(() => _gender = value ?? 'Prefer not to say'),
            decoration: const InputDecoration(
              hintText: 'Gender',
              prefixIcon: Icon(Icons.people_outline),
            ),
          ),
        ],
      ),
    );
  }

  // — Step 1: Interests —
  Widget _buildStepInterests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader(
            '🎯',
            'What are you into?',
            'Pick your vibes. Our AI uses these for matching.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _interestData.map((item) {
              final selected =
                  _selectedInterests.contains(item.$2.toLowerCase());
              return GestureDetector(
                onTap: () {
                  setState(() {
                    final val = item.$2.toLowerCase();
                    if (selected) {
                      _selectedInterests.remove(val);
                    } else {
                      _selectedInterests.add(val);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? VynkColors.primary.withValues(alpha: 0.15)
                        : VynkColors.surfaceLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected
                          ? VynkColors.primary
                          : Colors.white.withValues(alpha: 0.06),
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: selected
                        ? VynkColors.primaryGlow(opacity: 0.1)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.$1, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        item.$2,
                        style: TextStyle(
                          color: selected
                              ? VynkColors.primary
                              : VynkColors.textSecondary,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: VynkColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: VynkColors.accent.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome,
                    size: 16, color: VynkColors.accentLight),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Selected ${_selectedInterests.length} interests — these feed into the AI matching algorithm.',
                    style: TextStyle(
                      color: VynkColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // — Step 2: Personality Q1-Q2 (E/I axis focus) —
  Widget _buildStepPersonality1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader(
            '🧠',
            'Personality Deep Dive',
            'These responses train our AI to identify your personality type.',
          ),
          const SizedBox(height: 8),
          _axisHint('E/I Axis', 'Extraversion vs. Introversion'),
          const SizedBox(height: 16),
          _promptCard(
            '1',
            '☀️ Describe your ideal weekend.',
            'Do you recharge around people or in solitude?',
          ),
          _promptCard(
            '2',
            '🤝 Do you prefer working in teams or independently?',
            'What energizes you — collaboration or solo focus?',
          ),
        ],
      ),
    );
  }

  // — Step 3: Personality Q3-Q5 (S/N, T/F axes) —
  Widget _buildStepPersonality2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader(
            '💡',
            'How You Think & Feel',
            'Our AI analyzes your language patterns to detect cognitive style.',
          ),
          const SizedBox(height: 8),
          _axisHint('S/N + T/F Axes', 'Sensing vs. Intuition  •  Thinking vs. Feeling'),
          const SizedBox(height: 16),
          _promptCard(
            '3',
            '⚡ How do you make decisions under pressure?',
            'Logic-first or gut-feeling-first?',
          ),
          _promptCard(
            '4',
            '❤️ How do you handle conflict or disagreements?',
            'Do you analyze or empathize first?',
          ),
          _promptCard(
            '5',
            '🔥 What motivates you — logic & strategy, or values & emotions?',
            'This directly maps to the Thinking/Feeling axis.',
          ),
        ],
      ),
    );
  }

  // — Step 4: Personality Q6-Q8 (J/P axis + wrap-up) —
  Widget _buildStepPersonality3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader(
            '🎯',
            'Your Lifestyle DNA',
            'Final prompts — these determine your J/P axis and overall fit.',
          ),
          const SizedBox(height: 8),
          _axisHint('J/P Axis', 'Judging vs. Perceiving'),
          const SizedBox(height: 16),
          _promptCard(
            '6',
            '📋 How do you usually plan your week?',
            'Structured planner or go-with-the-flow?',
          ),
          _promptCard(
            '7',
            '🌍 Do you prefer a structured routine or spontaneous lifestyle?',
            'This maps directly to how you approach life.',
          ),
          _promptCard(
            '8',
            '✨ What type of people energize you most?',
            'Think about your ideal social circle.',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  VynkColors.primary.withValues(alpha: 0.1),
                  VynkColors.accent.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: VynkColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.psychology,
                    size: 20, color: VynkColors.primaryLight),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis Ready',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: VynkColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hit the button below to run NLP analysis on your responses and reveal your MBTI type.',
                        style: TextStyle(
                          color: VynkColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // — Shared widgets —

  Widget _stepHeader(String emoji, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) =>
              VynkColors.heroGradient.createShader(bounds),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(color: VynkColors.textMuted),
        ),
      ],
    );
  }

  Widget _axisHint(String axis, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: VynkColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: VynkColors.accent.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: VynkColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              axis,
              style: TextStyle(
                color: VynkColors.accentLight,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: VynkColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promptCard(String id, String title, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VynkColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: VynkColors.textPrimary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hint,
            style: TextStyle(
              color: VynkColors.textMuted,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _responseControllers[id],
            maxLines: 3,
            style: const TextStyle(
              color: VynkColors.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Write freely...',
              filled: true,
              fillColor: VynkColors.background.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String label;
  final IconData icon;

  const _GradientButton({
    required this.onPressed,
    this.loading = false,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: onPressed != null ? VynkColors.heroGradient : null,
          color: onPressed == null
              ? VynkColors.textMuted.withValues(alpha: 0.3)
              : null,
          borderRadius: BorderRadius.circular(28),
          boxShadow:
              onPressed != null ? VynkColors.primaryGlow(opacity: 0.25) : null,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
