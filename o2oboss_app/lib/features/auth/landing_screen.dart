import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../shared/widgets/pills.dart';

/// Landing page with carousel and "Grow With Us" CTA
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  static const _images = [
    'assets/images/carousel/043753f5-1b62-4e99-8e84-bd588ef22b6a.jpg',
    'assets/images/carousel/0e52d1d9-07cf-42e5-a8bb-b634804e5bc7.jpg',
    'assets/images/carousel/55a5ef61-15fd-45ed-9526-9e2d7df7c0bd.jpg',
    'assets/images/carousel/6b10a3ba-68c3-4088-bc12-56fddcd056a4.jpg',
    'assets/images/carousel/a6a78b75-f85a-4fc7-8749-4219b178a1c0.jpg',
    'assets/images/carousel/ce8e9d13-6e94-4257-b465-548aeb1f046c.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_currentPage + 1) % _images.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/images/bg_pattern.png', fit: BoxFit.cover,
              color: Colors.white.withValues(alpha: 0.9), colorBlendMode: BlendMode.srcOver),
          ),
          SafeArea(
            child: Column(children: [
              const SizedBox(height: Space.xl),
              Center(child: BrandMark(size: 80)),
              const SizedBox(height: Space.lg),
              Text('Making A LIFE...\nNot Just A Living...', textAlign: TextAlign.center,
                style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.3)),
              const SizedBox(height: Space.xl),
              // Carousel
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                  child: ClipRRect(
                    borderRadius: Corners.xlAll,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemCount: _images.length,
                      itemBuilder: (_, i) => Image.asset(_images[i], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              // Dots
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < _images.length; i++)
                  AnimatedContainer(duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8, height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4))),
              ]),
              const SizedBox(height: Space.xxl),
              // CTA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.xl),
                child: SizedBox(width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.go(Routes.login),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: Corners.lgAll)),
                    child: Text('Grow With Us', style: context.text.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700))))),
              const SizedBox(height: Space.lg),
              TextButton(onPressed: () => context.go(Routes.login),
                child: Text('Already have an account? Sign In',
                  style: context.text.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(height: Space.xl),
            ]),
          ),
        ],
      ),
    );
  }
}
