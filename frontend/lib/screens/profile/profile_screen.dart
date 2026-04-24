import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = ApiService();
  late Future<UserProfile> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.myProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: FutureBuilder<UserProfile>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text('Age: ${user.age ?? '-'}'),
              Text('Gender: ${user.gender ?? '-'}'),
              const SizedBox(height: 10),
              Text('MBTI: ${user.mbti ?? 'Not analyzed yet'}'),
              if (user.confidence != null)
                Text(
                  'Confidence Score: ${(user.confidence! * 100).toStringAsFixed(0)}%',
                ),
              const SizedBox(height: 10),
              Text('Interests: ${user.interests.join(', ')}'),
            ],
          );
        },
      ),
    );
  }
}
