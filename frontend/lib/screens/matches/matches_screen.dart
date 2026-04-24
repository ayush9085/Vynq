import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _api = ApiService();
  late Future<List<MatchItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.findMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Matches')),
      body: FutureBuilder<List<MatchItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final matches = snapshot.data ?? [];
          if (matches.isEmpty) {
            return const Center(
              child: Text(
                'No matches yet. Add more users and complete onboarding.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: matches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = matches[index];
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.mbti}  •  Compatibility: ${item.compatibilityScore.toStringAsFixed(0)}% Match',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.go('/home/match-detail', extra: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
