import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';
import '../../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _api.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      context.go('/home');
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
          // Background gradient orbs
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.primary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VynkColors.accent.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Logo
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            VynkColors.heroGradient.createShader(bounds),
                        child: const Icon(
                          Icons.favorite,
                          size: 48,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(
                        begin: const Offset(0.5, 0.5),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            VynkColors.heroGradient.createShader(bounds),
                        child: const Text(
                          'VYNK',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.white,
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                      const SizedBox(height: 6),
                      Text(
                        'Swipe less. Connect deeper.',
                        style: TextStyle(
                          fontSize: 14,
                          color: VynkColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                      const SizedBox(height: 36),

                      // Glass card
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome back',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: VynkColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your next spark might be one tap away.',
                                    style: TextStyle(
                                      color: VynkColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  if (_error != null)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 16),
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
                                        style: const TextStyle(
                                          color: VynkColors.nope,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ).animate().fadeIn().shake(),

                                  TextField(
                                    controller: _email,
                                    style: const TextStyle(color: VynkColors.textPrimary),
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  TextField(
                                    controller: _password,
                                    obscureText: _obscure,
                                    style: const TextStyle(color: VynkColors.textPrimary),
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () =>
                                            setState(() => _obscure = !_obscure),
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

                                  // Gradient CTA button
                                  _GradientButton(
                                    onPressed: _loading ? null : _submit,
                                    loading: _loading,
                                    label: 'Enter Vynk',
                                    icon: Icons.favorite,
                                  ),
                                  const SizedBox(height: 20),

                                  // Social login hint
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: VynkColors.textMuted
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'or continue with',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: VynkColors.textMuted,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: VynkColors.textMuted
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      _SocialButton(icon: Icons.g_mobiledata),
                                      const SizedBox(width: 16),
                                      _SocialButton(icon: Icons.apple),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          context.go('/auth/register'),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: VynkColors.textMuted,
                                          ),
                                          children: [
                                            const TextSpan(text: 'New here? '),
                                            TextSpan(
                                              text: 'Create account',
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
          boxShadow: onPressed != null ? VynkColors.primaryGlow(opacity: 0.25) : null,
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

class _SocialButton extends StatelessWidget {
  final IconData icon;

  const _SocialButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: glassDecoration(
        opacity: 0.06,
        borderRadius: 16,
        borderOpacity: 0.1,
      ),
      child: Icon(icon, color: VynkColors.textSecondary, size: 28),
    );
  }
}
