import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animation
    _animationController.forward();

    // Navigate after splash duration
    Future.delayed(const Duration(seconds: 3), _handleNavigation);
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('vynk_auth_token');

    if (token != null) {
      // User is logged in, check if onboarding is completed
      final isOnboardingDone = await ApiService.isOnboardingCompleted();
      if (mounted) {
        if (isOnboardingDone) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      }
    } else {
      if (mounted) context.go('/auth/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: VynkColors.lavenderGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Text(
                      'VYNK',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: VynkColors.primary,
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '👀',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Tagline
              Text(
                'Let\'s see who you vynk with',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: VynkColors.textLight,
                    ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(VynkColors.primary),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
