import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../services/api_service.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiService();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _boot();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    final isAuthed = await _api.isAuthenticated();
    if (!mounted) return;
    context.go(isAuthed ? '/home' : '/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      body: Stack(
        children: [
          // Animated gradient background orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 4.seconds,
                  curve: Curves.easeInOut,
                ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.accent.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(0.8, 0.8),
                  duration: 4.seconds,
                  curve: Curves.easeInOut,
                ),
          ),
          // Blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated heart icon
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.15),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            VynkColors.heroGradient.createShader(bounds),
                        child: const Icon(
                          Icons.favorite,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.5, 0.5)),
                const SizedBox(height: 24),
                // Logo text
                ShaderMask(
                  shaderCallback: (bounds) =>
                      VynkColors.heroGradient.createShader(bounds),
                  child: const Text(
                    'VYNK',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 12),
                Text(
                  'Let\'s see who you vynk with',
                  style: TextStyle(
                    fontSize: 16,
                    color: VynkColors.textSecondary,
                    letterSpacing: 1,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms),
                const SizedBox(height: 40),
                // Loading dots
                SizedBox(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (i) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: VynkColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(
                            onPlay: (c) => c.repeat(reverse: true),
                          )
                          .fadeIn(delay: (200 * i).ms)
                          .then()
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.0, 1.0),
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          );
                    }),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
