import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final isCompleted = await ApiService.isOnboardingCompleted();
    if (mounted) {
      setState(() {
        _isOnboardingCompleted = isCompleted;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(VynkColors.primary),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('VYNK 👀'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/home/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _apiService.logout();
              if (mounted) context.go('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: VynkColors.lavenderGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to VYNK 👀',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: VynkColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s find your perfect match',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: VynkColors.textLight,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // If onboarding not completed, show prompt
            if (!_isOnboardingCompleted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: VynkColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: VynkColors.lavenderAccent.withValues(alpha: 0.3),
                ),
                child: Column(
                  children: [
                    Text(
                      '⚠️ Complete Your Profile First',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: VynkColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Answer a few quick questions about yourself to get personalized matches!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.push('/onboarding'),
                      child: const Text('Start Onboarding'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            // Quick actions section
            Text(
              'Discover Matches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isOnboardingCompleted
                  ? () => context.push('/home/matches')
                  : null,
              icon: const Icon(Icons.favorite),
              label: const Text('View Matches'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/home/profile'),
              icon: const Icon(Icons.person),
              label: const Text('My Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
