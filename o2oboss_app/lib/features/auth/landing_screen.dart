import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';

import '../../app/theme/app_typography.dart';
import '../../shared/widgets/pills.dart';

/// Landing page with carousel and "Grow With Us" CTA
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _fadeCtrl;

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
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage((_currentPage + 1) % _images.length,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final small = h < 700;
    return Scaffold(
      body: Stack(children: [
        // Background pattern - no overlay, show as-is
        Positioned.fill(child: Image.asset('assets/images/bg_pattern.png', fit: BoxFit.cover)),
        SafeArea(child: FadeTransition(opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
          child: Column(children: [
            SizedBox(height: small ? 16 : 24),
            TweenAnimationBuilder<double>(tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 500), curve: Curves.elasticOut,
              builder: (_, s, c) => Transform.scale(scale: s, child: c),
              child: BrandMark(size: small ? 56 : 68)),
            SizedBox(height: small ? 8 : 12),
            Text('Making A LIFE...\nNot Just A Living...', textAlign: TextAlign.center,
              style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.3, fontSize: small ? 17 : 21, color: AppColors.text)),
            SizedBox(height: small ? 16 : 20),
            Expanded(child: _buildCarousel(small)),
            SizedBox(height: small ? 12 : 16),
            _buildDots(),
            SizedBox(height: small ? 24 : 32),
            _buildCTA(context, small),
            SizedBox(height: small ? 10 : 14),
            TextButton(onPressed: () => context.go(Routes.login),
              child: Text('Already have an account? Sign In',
                style: context.text.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: small ? 13 : 14))),
            SizedBox(height: small ? 16 : 24),
          ]))),
      ]),
    );
  }

  Widget _buildCarousel(bool small) => PageView.builder(
    controller: _pageController,
    onPageChanged: (i) => setState(() => _currentPage = i),
    itemCount: _images.length,
    itemBuilder: (_, i) => AnimatedBuilder(animation: _pageController, builder: (_, child) {
      double v = 1.0;
      if (_pageController.position.haveDimensions) v = (_pageController.page! - i).abs().clamp(0.0, 1.0);
      return Transform.scale(scale: 1 - v * 0.06, child: Opacity(opacity: 1 - v * 0.25, child: child));
    }, child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))]),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), 
        child: Image.asset(_images[i], fit: BoxFit.contain, width: double.infinity)))));

  Widget _buildDots() => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    for (var i = 0; i < _images.length; i++)
      GestureDetector(onTap: () => _pageController.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut),
        child: AnimatedContainer(duration: const Duration(milliseconds: 220), curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3), width: _currentPage == i ? 18 : 6, height: 6,
          decoration: BoxDecoration(color: _currentPage == i ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3))))]);

  Widget _buildCTA(BuildContext ctx, bool small) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: SizedBox(width: double.infinity, height: small ? 50 : 56,
      child: ElevatedButton(
        onPressed: () {
          debugPrint('Grow With Us tapped - navigating to login');
          ctx.go(Routes.login);
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          elevation: 4, shadowColor: AppColors.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        child: Text('Grow With Us', style: ctx.text.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: small ? 16 : 18)))));
}
