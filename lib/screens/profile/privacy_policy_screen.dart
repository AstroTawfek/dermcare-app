import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
 
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/profile')),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _lastUpdated('Last updated: January 2025'),
          _policySection('1. Information We Collect',
            'DermCare collects personal information that you provide directly, including your name, email address, phone number, and appointment details. We also collect usage data such as the screens you visit and the features you use within the app.'),
          _policySection('2. How We Use Your Information',
            'Your information is used to:\n• Create and manage your account\n• Schedule and track your appointments\n• Send appointment reminders and notifications\n• Improve app features and performance\n• Respond to your support requests'),
          _policySection('3. Data Storage & Firebase',
            'Your data is securely stored using Google Firebase, which complies with international data protection standards. All data is encrypted in transit using HTTPS and at rest using AES-256 encryption.'),
          _policySection('4. Data Sharing',
            'DermCare does not sell, trade, or rent your personal information to third parties. Your data may be shared with healthcare providers (doctors listed in the app) only to facilitate your appointment.'),
          _policySection('5. Your Rights',
            'You have the right to:\n• Access your personal data\n• Correct inaccurate information\n• Delete your account and all associated data\n• Withdraw consent at any time\n\nTo exercise these rights, contact us at the email below.'),
          _policySection('6. Cookies & Local Storage',
            'The app uses local storage (SharedPreferences) only to save your notification and display preferences. No tracking cookies are used.'),
          _policySection('7. Children\'s Privacy',
            'DermCare is not intended for users under the age of 13. We do not knowingly collect personal information from children.'),
          _policySection('8. Changes to This Policy',
            'We may update this Privacy Policy from time to time. You will be notified of significant changes through the app or by email. Continued use of the app after changes means you accept the updated policy.'),
          _policySection('9. Contact Us',
            'If you have questions about this Privacy Policy, contact us at:\n\nEmail: privacy@dermcare.app\nAddress: Dhaka, Bangladesh'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
 
  Widget _lastUpdated(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(text, style: const TextStyle(
      fontSize: 12, color: AppColors.greyText, fontStyle: FontStyle.italic)),
  );
 
  Widget _policySection(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold,
            color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(
            fontSize: 13, color: AppColors.bodyText, height: 1.6)),
        ],
      ),
    );
  }
}