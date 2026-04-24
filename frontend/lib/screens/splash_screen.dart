import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api_service.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final isAuthed = await _api.isAuthenticated();
    if (!mounted) return;
    context.go(isAuthed ? '/home' : '/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: VynkColors.heroGradient),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VYNK',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Let\'s see who you vynk with',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 22),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
