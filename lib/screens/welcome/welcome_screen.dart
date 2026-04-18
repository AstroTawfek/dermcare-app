import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration / Logo area
              Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  color: AppColors.skyBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.health_and_safety,
                  size: 110, color: AppColors.primary),
              ),
              const SizedBox(height: 40),
              const Text('Welcome to DermCare', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                  color: AppColors.darkText)),
              const SizedBox(height: 12),
              const Text(
                'Find certified dermatologists near you.\n'
                'Book appointments easily and manage your skin health.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.greyText, height: 1.5),
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Get Started',
                onPressed: () => context.go('/signup'),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Already have an account? Login',
                  style: TextStyle(color: AppColors.primary,
                    fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}