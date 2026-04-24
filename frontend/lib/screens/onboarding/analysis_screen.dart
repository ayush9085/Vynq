import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';

class AnalysisScreen extends StatelessWidget {
  final MbtiResult result;

  const AnalysisScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AI Personality Analysis Complete',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  result.mbti,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Confidence Score: ${(result.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(result.message, textAlign: TextAlign.center),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Discover Matches'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
