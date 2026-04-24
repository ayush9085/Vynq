import 'package:flutter/material.dart';

import '../../models/api_models.dart';

class MatchDetailScreen extends StatelessWidget {
  final MatchItem match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${match.compatibilityScore.toStringAsFixed(0)}% Match',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text('MBTI: ${match.mbti}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 18),
            const Text(
              'Why you match',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(match.explanation),
            const SizedBox(height: 14),
            ...match.reasons.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(r)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Shared interests: ${match.sharedInterests.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
