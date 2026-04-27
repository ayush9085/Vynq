import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _api.register(
        email: _email.text.trim(),
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      context.go('/onboarding');
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VynkColors.background,
      body: Stack(
        children: [
          // Background orbs
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.accent.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Logo area
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            VynkColors.heroGradient.createShader(bounds),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 40,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 12),
                      const Text(
                        'Join Vynk',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: VynkColors.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      const SizedBox(height: 6),
                      Text(
                        'AI-powered personality matching awaits.',
                        style: TextStyle(color: VynkColors.textMuted),
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 28),

                      // Glass form card
                      Container(
                        decoration: glassDecoration(
                          opacity: 0.06,
                          borderRadius: 24,
                          borderOpacity: 0.08,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  if (_error != null)
                                    Container(
                                      width: double.infinity,
                                      margin:
                                          const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: VynkColors.nope
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: VynkColors.nope
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        _error!,
                                        style: const TextStyle(
                                          color: VynkColors.nope,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ).animate().fadeIn().shake(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _firstName,
                                          style: const TextStyle(
                                            color: VynkColors.textPrimary,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: 'First Name',
                                            prefixIcon:
                                                Icon(Icons.person_outline),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _lastName,
                                          style: const TextStyle(
                                            color: VynkColors.textPrimary,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: 'Last Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  TextField(
                                    controller: _email,
                                    style: const TextStyle(
                                      color: VynkColors.textPrimary,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  TextField(
                                    controller: _password,
                                    obscureText: _obscure,
                                    style: const TextStyle(
                                      color: VynkColors.textPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Password (min 6)',
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(
                                          () => _obscure = !_obscure,
                                        ),
                                        icon: Icon(
                                          _obscure
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: VynkColors.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _GradientButton(
                                    onPressed: _loading ? null : _submit,
                                    loading: _loading,
                                    label: 'Start Personality Setup',
                                    icon: Icons.auto_awesome,
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          context.go('/auth/login'),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: VynkColors.textMuted,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Already have an account? ',
                                            ),
                                            TextSpan(
                                              text: 'Login',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 600.ms)
                          .slideY(begin: 0.15, end: 0),
                    ],
                  ),
                ),
              ),
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
