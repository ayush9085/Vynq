import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _api = ApiService();

  final _age = TextEditingController();
  String _gender = 'Prefer not to say';
  final List<String> _selectedInterests = [];
  final Map<String, TextEditingController> _responseControllers = {
    '1': TextEditingController(),
    '2': TextEditingController(),
    '3': TextEditingController(),
    '4': TextEditingController(),
  };

  int _step = 0;
  bool _loading = false;
  String? _error;

  static const interests = [
    'music',
    'travel',
    'fitness',
    'gaming',
    'books',
    'coffee',
    'art',
    'movies',
    'nature',
    'coding',
  ];

  @override
  void dispose() {
    _age.dispose();
    for (final c in _responseControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final parsedAge = int.tryParse(_age.text);
    if (parsedAge == null) {
      setState(() => _error = 'Enter a valid age');
      return;
    }
    if (_selectedInterests.isEmpty) {
      setState(() => _error = 'Select at least one interest');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final responses = <String, String>{};
      for (final entry in _responseControllers.entries) {
        responses[entry.key] = entry.value.text.trim();
      }

      await Future<void>.delayed(const Duration(seconds: 2));
      final MbtiResult result = await _api.completeOnboarding(
        age: parsedAge,
        gender: _gender,
        interests: _selectedInterests,
        responses: responses,
      );
      if (!mounted) return;
      context.go('/analysis', extra: result);
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildStepBasicInfo(),
      _buildStepInterests(),
      _buildStepResponses(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Onboarding ${_step + 1}/3')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_error != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            Expanded(child: pages[_step]),
            Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() => _step -= 1),
                      child: const Text('Back'),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : _step < 2
                        ? () => setState(() => _step += 1)
                        : _submit,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_step < 2 ? 'Next' : 'Run AI Analysis'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Basic Info',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _age,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Age'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _gender,
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
            DropdownMenuItem(
              value: 'Prefer not to say',
              child: Text('Prefer not to say'),
            ),
          ],
          onChanged: (value) =>
              setState(() => _gender = value ?? 'Prefer not to say'),
          decoration: const InputDecoration(hintText: 'Gender'),
        ),
      ],
    );
  }

  Widget _buildStepInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2: Interests',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text('Pick your interests for better matching.'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((item) {
            final selected = _selectedInterests.contains(item);
            return FilterChip(
              selected: selected,
              label: Text(item),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectedInterests.add(item);
                  } else {
                    _selectedInterests.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStepResponses() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 3: Personality Prompts',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Write freely. Your AI personality analysis will use these answers.',
          ),
          const SizedBox(height: 14),
          _prompt('1', 'Describe your ideal weekend.'),
          _prompt('2', 'How do you make decisions under pressure?'),
          _prompt('3', 'What type of people energize you?'),
          _prompt('4', 'How do you organize your week?'),
        ],
      ),
    );
  }

  Widget _prompt(String id, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _responseControllers[id],
        maxLines: 3,
        decoration: InputDecoration(labelText: title, alignLabelWithHint: true),
      ),
    );
  }
}
