import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _apiService = ApiService();
  int _currentStep = 0;
  int? _age;
  String? _gender;
  final List<String> _selectedInterests = [];
  bool _isSubmitting = false;

  late PageController _pageController;

  static const List<String> _availableInterests = [
    'Music',
    'Sports',
    'Travel',
    'Art',
    'Photography',
    'Cooking',
    'Gaming',
    'Fitness',
    'Reading',
    'Movies',
    'Technology',
    'Nature',
    'Fashion',
    'Coffee',
    'Yoga',
  ];

  static const List<String> _questions = [
    'I prefer action over contemplation',
    'I focus on the actual situation',
    'Logic is more important than feelings',
    'I prefer structured plans',
  ];

  final Map<int, String> _answers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_age == null || _gender == null || _selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await _apiService.completeOnboarding(
        age: _age!,
        gender: _gender!,
        interests: _selectedInterests,
        responses: _answers.map((k, v) => MapEntry(k.toString(), v)),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Your Vibe is...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.mbtiType,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(color: VynkColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                result.message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Mark onboarding as completed
                await ApiService.markOnboardingCompleted();
                if (mounted) {
                  Navigator.pop(context);
                  context.go('/home');
                }
              },
              child: const Text('Let\'s Go!'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: VynkColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Step ${_currentStep + 1}/3'), elevation: 0),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentStep = index);
        },
        children: [
          _buildBasicInfoStep(),
          _buildInterestsStep(),
          _buildAssessmentStep(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about yourself',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
          Text('Age', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter your age',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() => _age = int.tryParse(value));
            },
          ),
          const SizedBox(height: 24),
          Text('Gender', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            value: _gender,
            items: [
              'Male',
              'Female',
              'Other',
              'Prefer not to say',
            ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (value) {
              setState(() => _gender = value);
            },
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _age != null && _gender != null
                  ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                  : null,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What interests you?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Select at least 3',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                backgroundColor: VynkColors.secondary.withOpacity(0.3),
                selectedColor: VynkColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : VynkColors.textDark,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedInterests.length >= 3
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answer a few questions',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us understand your personality',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ..._questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(question, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _answers[index] = 'Disagree');
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _answers[index] == 'Disagree'
                              ? VynkColors.primary
                              : Colors.transparent,
                        ),
                        child: Text(
                          'Disagree',
                          style: TextStyle(
                            color: _answers[index] == 'Disagree'
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _answers[index] = 'Neutral');
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _answers[index] == 'Neutral'
                              ? VynkColors.primary
                              : Colors.transparent,
                        ),
                        child: Text(
                          'Neutral',
                          style: TextStyle(
                            color: _answers[index] == 'Neutral'
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _answers[index] = 'Agree');
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _answers[index] == 'Agree'
                              ? VynkColors.primary
                              : Colors.transparent,
                        ),
                        child: Text(
                          'Agree',
                          style: TextStyle(
                            color: _answers[index] == 'Agree'
                                ? Colors.white
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            );
          }),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _completeOnboarding,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Analyze'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
