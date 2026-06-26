import 'package:flutter/material.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';
import 'package:fitness_tracker/features/onboarding/presentation/models/onboarding_page_model.dart';
import 'package:fitness_tracker/features/onboarding/presentation/widgets/onboarding_page_widget.dart';

/// The onboarding screen widget.
///
/// Implements a 4-page introduction flow displaying App titles and subtitles
/// using [PageView], dot indicators, and transition buttons (Skip, Next, Get Started).
/// No business logic, persistence, or routing is implemented yet, as per
/// Step 3.3.1 requirements.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // The 4 onboarding page models defined with requested titles, subtitles,
  // and corresponding Material icons.
  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel(
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      icon: Icons.fitness_center,
    ),
    OnboardingPageModel(
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      icon: Icons.directions_run,
    ),
    OnboardingPageModel(
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
      icon: Icons.insights,
    ),
    OnboardingPageModel(
      title: AppStrings.onboardingTitle4,
      subtitle: AppStrings.onboardingSubtitle4,
      icon: Icons.emoji_events,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  /// Slides the [PageView] forward by one page.
  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Jumps the [PageView] directly to the last page.
  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// Visual placeholder for completion interaction.
  void _onGetStarted() {
    // Placeholder function; no routing or persistence implemented yet.
    debugPrint('Get Started pressed.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPageIndex == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top control bar containing the Skip button (invisible on the final page)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  opacity: isLastPage ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: isLastPage,
                    child: TextButton(
                      key: const Key('onboarding_skip_button'),
                      onPressed: _skipOnboarding,
                      child: Text(
                        AppStrings.onboardingSkip,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Middle section containing the PageView contents
            Expanded(
              child: PageView.builder(
                key: const Key('onboarding_page_view'),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(model: _pages[index]);
                },
              ),
            ),

            // Bottom control bar containing Page Indicators and Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Page Indicators (dots)
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index, theme),
                    ),
                  ),

                  // 2. Action Button (Next or Get Started)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isLastPage
                        ? ElevatedButton(
                            key: const Key('onboarding_get_started_button'),
                            onPressed: _onGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              AppStrings.onboardingGetStarted,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            key: const Key('onboarding_next_button'),
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              AppStrings.onboardingNext,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a customized dot indicator matching Active/Inactive theme colors.
  Widget _buildIndicator(int index, ThemeData theme) {
    final isActive = _currentPageIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withAlpha(80),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
