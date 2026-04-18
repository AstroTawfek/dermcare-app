import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Sample notification data — replace with real Firestore data later
  static const List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.check_circle,
      'color': 0xFF2E7D32,
      'title': 'Appointment Confirmed',
      'body':
          'Your appointment with Dr. Ayesha Rahman on Mon, 20 Jan is confirmed.',
      'time': '2 hours ago'
    },
    {
      'icon': Icons.alarm,
      'color': 0xFFF57F17,
      'title': 'Appointment Reminder',
      'body': 'You have an appointment tomorrow at 10:00 AM.',
      'time': 'Yesterday'
    },
    {
      'icon': Icons.person_add,
      'color': 0xFF1565C0,
      'title': 'New Doctor Available',
      'body': 'Dr. Md. Karim has joined DermCare and is now available.',
      'time': '3 days ago'
    },
    {
      'icon': Icons.cancel,
      'color': 0xFFC62828,
      'title': 'Appointment Cancelled',
      'body': 'Your appointment on 12 Jan was cancelled. Please rebook.',
      'time': '1 week ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.go('/home')),
        actions: [
          IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              tooltip: 'Messages',
              onPressed: () => context.go('/chat')),
        ],
        elevation: 0,
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No notifications yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final n = _notifications[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(n['color'] as int).withOpacity(0.12),
                            shape: BoxShape.circle),
                        child: Icon(n['icon'] as IconData,
                            color: Color(n['color'] as int), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n['title'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(n['body'] as String,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.bodyText,
                                    height: 1.4)),
                            const SizedBox(height: 6),
                            Text(n['time'] as String,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.greyText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
