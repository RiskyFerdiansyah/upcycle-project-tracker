import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

enum OnboardingIllustration { welcome, discover, community }

class OnboardingPageContent {
  const OnboardingPageContent({
    required this.title,
    required this.description,
    required this.illustration,
  });

  final String title;
  final String description;
  final OnboardingIllustration illustration;
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.illustration,
    super.key,
  });

  final String title;
  final String description;
  final OnboardingIllustration illustration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final artworkHeight = (constraints.maxHeight * 0.52)
            .clamp(170.0, 310.0)
            .toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: artworkHeight,
                  child: _OnboardingArtwork(illustration: illustration),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingArtwork extends StatelessWidget {
  const _OnboardingArtwork({required this.illustration});

  final OnboardingIllustration illustration;

  @override
  Widget build(BuildContext context) {
    final isWelcome = illustration == OnboardingIllustration.welcome;
    final isCommunity = illustration == OnboardingIllustration.community;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE7F2E3), Color(0xFFF4F6E9)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            right: 24,
            child: _DecorationBubble(
              icon: isWelcome
                  ? Icons.eco_rounded
                  : isCommunity
                  ? Icons.public_rounded
                  : Icons.lightbulb_rounded,
              size: 48,
            ),
          ),
          Positioned(
            top: 66,
            left: 20,
            child: _DecorationBubble(
              icon: isWelcome
                  ? Icons.spa_rounded
                  : isCommunity
                  ? Icons.volunteer_activism_rounded
                  : Icons.auto_awesome_rounded,
              size: 36,
              pale: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
            child: isWelcome
                ? _WelcomeArtwork()
                : _DiscoverArtwork(community: isCommunity),
          ),
          Positioned(
            bottom: 14,
            left: 18,
            child: _DecorationBubble(
              icon: isWelcome
                  ? Icons.local_drink_rounded
                  : isCommunity
                  ? Icons.share_rounded
                  : Icons.handyman_rounded,
              size: 42,
              pale: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeArtwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = (constraints.maxHeight * 0.62)
            .clamp(76.0, 142.0)
            .toDouble();
        final compact =
            constraints.maxHeight < 230 || constraints.maxWidth < 250;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.mint, width: 8),
              ),
              child: Icon(
                Icons.recycling_rounded,
                color: AppColors.primary,
                size: circleSize * 0.55,
              ),
            ),
            SizedBox(height: compact ? 8 : 20),
            Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth - 8),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 10 : 16,
                vertical: compact ? 6 : 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'REUSE  ·  REIMAGINE  ·  RECREATE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DiscoverArtwork extends StatelessWidget {
  const _DiscoverArtwork({this.community = false});

  final bool community;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = (constraints.maxHeight * 0.48)
            .clamp(64.0, 124.0)
            .toDouble();
        final compact =
            constraints.maxHeight < 230 || constraints.maxWidth < 270;
        final tileSize = compact ? 40.0 : 48.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                community ? Icons.groups_rounded : Icons.lightbulb_rounded,
                color: community ? AppColors.primary : AppColors.accent,
                size: circleSize * 0.55,
              ),
            ),
            SizedBox(height: compact ? 8 : 18),
            Container(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight * 0.44,
              ),
              padding: EdgeInsets.all(compact ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: tileSize,
                    height: tileSize,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      community
                          ? Icons.volunteer_activism_rounded
                          : Icons.local_florist_rounded,
                      color: AppColors.primary,
                      size: tileSize * 0.58,
                    ),
                  ),
                  SizedBox(width: compact ? 8 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          community
                              ? 'Made better together'
                              : 'Tin can planter',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.text,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          community
                              ? 'Share projects, tips and inspiration'
                              : 'A fresh idea for old materials',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.mutedText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DecorationBubble extends StatelessWidget {
  const _DecorationBubble({
    required this.icon,
    required this.size,
    this.pale = false,
  });

  final IconData icon;
  final double size;
  final bool pale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: pale ? Colors.white.withValues(alpha: 0.8) : AppColors.mint,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.secondary, size: size * 0.52),
    );
  }
}
