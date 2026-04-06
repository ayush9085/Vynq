import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../models/api_models.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  final _apiService = ApiService();
  late Future<List<Match>> _matchesFuture;
  late AnimationController _cardController;
  late AnimationController _actionController;
  int _currentIndex = 0;
  List<Match> _matches = [];

  @override
  void initState() {
    super.initState();
    _matchesFuture = _apiService.findMatches();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _actionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void _onSwipe(bool isLike) async {
    await _actionController.forward().then((_) {
      _actionController.reverse();
    });

    setState(() {
      _currentIndex++;
    });
  }

  void _onSuperLike() async {
    await _actionController.forward().then((_) {
      _actionController.reverse();
    });

    setState(() {
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💘 Discover'),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              VynkColors.lavender,
              VynkColors.background,
            ],
          ),
        ),
        child: FutureBuilder<List<Match>>(
          future: _matchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(VynkColors.primary),
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState(context, snapshot.error);
            }

            _matches = snapshot.data ?? [];

            if (_matches.isEmpty) {
              return _buildEmptyState(context);
            }

            if (_currentIndex >= _matches.length) {
              return _buildNoMoreState(context);
            }

            return Stack(
              children: [
                // Background cards (stack effect)
                if (_currentIndex + 1 < _matches.length)
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 100,
                    bottom: 180,
                    child: _buildProfileCard(
                      context,
                      _matches[_currentIndex + 1],
                      scale: 0.95,
                      offset: Offset.zero,
                    ),
                  ),
                // Main card
                Positioned(
                  left: 12,
                  right: 12,
                  top: 80,
                  bottom: 160,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) async {
                      if (details.primaryVelocity! < -500) {
                        // Swiped left (pass)
                        await _cardController.forward();
                        _onSwipe(false);
                        _cardController.reset();
                      } else if (details.primaryVelocity! > 500) {
                        // Swiped right (like)
                        await _cardController.forward();
                        _onSwipe(true);
                        _cardController.reset();
                      }
                    },
                    child: _buildProfileCard(
                      context,
                      _matches[_currentIndex],
                      scale: 1.0,
                      offset: Offset.zero,
                    ),
                  ),
                ),
                // Action buttons
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: _buildActionButtons(context),
                ),
                // Match counter
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: VynkColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${_matches.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Match match,
      {required double scale, required Offset offset}) {
    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: VynkColors.lavenderDeep.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: VynkColors.deepLavenderGradient,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            // Profile image placeholder
            Container(
              decoration: BoxDecoration(
                color: VynkColors.lavenderAccent.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: VynkColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: VynkColors.lavenderDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile info overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: VynkColors.primary.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              match.mbti,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                          CurvedAnimation(
                            parent: _actionController,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: VynkColors.superLike.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${match.compatibilityScore}% Match',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: match.interests
                        .take(3)
                        .map(
                          (interest) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            // Tap to see more
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () => context.push('/home/matches/${match.matchUserId}'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'See More',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
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
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass button
          GestureDetector(
            onTap: () {
              _onSwipe(false);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: VynkColors.pass.withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: VynkColors.pass.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                size: 28,
                color: VynkColors.pass,
              ),
            ),
          ),
          // Super like button
          GestureDetector(
            onTap: _onSuperLike,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [VynkColors.superLike, VynkColors.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: VynkColors.superLike.withValues(alpha: 0.4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          // Like button
          GestureDetector(
            onTap: () {
              _onSwipe(true);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: VynkColors.like.withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: VynkColors.like.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                size: 28,
                color: VynkColors.like,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    final errorMessage = error.toString().replaceAll('Exception: ', '');
    final isOnboardingRequired = errorMessage.contains('complete onboarding');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOnboardingRequired ? Icons.pending_actions : Icons.error_outline,
            size: 48,
            color: isOnboardingRequired
                ? VynkColors.primary
                : VynkColors.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            isOnboardingRequired
                ? 'Complete Your Profile'
                : 'Failed to load matches',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (isOnboardingRequired)
            ElevatedButton(
              onPressed: () => context.push('/onboarding'),
              child: const Text('Complete Onboarding'),
            )
          else
            ElevatedButton(
              onPressed: () =>
                  setState(() => _matchesFuture = _apiService.findMatches()),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 48,
            color: VynkColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No matches yet 💔',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your profile to find matches',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMoreState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 48,
            color: VynkColors.success,
          ),
          const SizedBox(height: 16),
          Text(
            'Great job! 🎉',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve seen all available matches',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }
}
