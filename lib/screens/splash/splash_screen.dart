import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), vsync: this,
    );
    _fadeAnimation  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
 
    // Navigate to welcome screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/welcome');
    });
  }
 
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_hospital,
                    size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text('DermCare', style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold,
                  color: Colors.white, letterSpacing: 1.5,
                )),
                const SizedBox(height: 8),
                Text('Your Skin Health Partner',
                  style: TextStyle(fontSize: 16,
                    color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}