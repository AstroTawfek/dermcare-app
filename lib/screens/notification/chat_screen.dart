import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
 
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/notification')),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction_rounded,
                size: 90, color: Colors.grey.shade400),
              const SizedBox(height: 24),
              const Text('This Page Is Not Developed Yet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: AppColors.darkText)),
              const SizedBox(height: 12),
              const Text(
                'Chat feature will be available in a future update of DermCare.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.greyText, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}