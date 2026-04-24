import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vynk'),
        actions: [
          IconButton(
            onPressed: () => context.go('/home/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            onPressed: () async {
              await ApiService().logout();
              if (context.mounted) context.go('/auth/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your personality match',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI-powered compatibility based on personality signals and shared interests.',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/home/matches'),
              icon: const Icon(Icons.favorite_outline),
              label: const Text('View Matches'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/onboarding'),
              icon: const Icon(Icons.psychology_outlined),
              label: const Text('Re-run AI Analysis'),
            ),
          ],
        ),
      ),
    );
  }
}
