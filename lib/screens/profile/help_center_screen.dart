import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
 
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});
 
  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I book an appointment?',
      'a': 'Go to the Home screen → tap a doctor card → tap \'Book Appointment\' on the doctor detail page → select a date and time slot → tap \'Confirm Booking\'.',
    },
    {
      'q': 'Can I cancel a booked appointment?',
      'a': 'Currently, cancellations are handled by contacting the clinic directly. A cancel button feature will be added in a future update.',
    },
    {
      'q': 'How do I filter doctors by gender?',
      'a': 'On the Home screen, tap \'Male Doctors\' or \'Female Doctors\' under the Browse By section. This shows only doctors of that gender.',
    },
    {
      'q': 'My appointment is not showing up — what do I do?',
      'a': 'Make sure you are logged in with the same account you used to book. Pull down on the Appointments screen to refresh. If still missing, contact support.',
    },
    {
      'q': 'How do I change my password?',
      'a': 'Go to Profile → Password Manager → enter your current password and then your new password → tap \'Change Password\'.',
    },
    {
      'q': 'Is my medical data secure?',
      'a': 'Yes. DermCare uses Google Firebase with AES-256 encryption for all stored data. Your information is never sold or shared with advertisers.',
    },
    {
      'q': 'I forgot my password. How do I reset it?',
      'a': 'On the Login screen, tap \'Forgot Password?\' (if visible), or contact support at help@dermcare.app and we will send a reset link.',
    },
    {
      'q': 'How do I update my profile information?',
      'a': 'Go to Profile → Edit Profile → update your name or phone number → tap \'Save Changes\'.',
    },
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help Center', style: TextStyle(
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
          // Search hint box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.help_outline, color: AppColors.primary, size: 22),
              SizedBox(width: 10),
              Expanded(child: Text('Frequently asked questions — tap a question to expand.',
                style: TextStyle(fontSize: 13, color: AppColors.bodyText))),
            ]),
          ),
          const SizedBox(height: 16),
          // FAQ list
          ..._faqs.map((faq) => _FaqTile(
            question: faq['q']!,
            answer: faq['a']!,
          )),
          const SizedBox(height: 20),
          // Contact support card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Still need help?', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                const Text('Our support team is ready to assist you.',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                Row(children: [
                  _contactChip(Icons.email_outlined, 'help@dermcare.app'),
                  const SizedBox(width: 8),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
 
  Widget _contactChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ]),
    );
  }
}
 
// Expandable FAQ tile widget
class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});
  @override State<_FaqTile> createState() => _FaqTileState();
}
 
class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 6)],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.question, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
            trailing: AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.primary)),
            onTap: () => setState(() => _expanded = !_expanded),
            contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(widget.answer, style: const TextStyle(
                fontSize: 13, color: AppColors.bodyText, height: 1.6)),
            ),
            crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}