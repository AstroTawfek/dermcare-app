import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav_bar.dart';
 
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Blue Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Column(children: [
                  // Tap avatar to edit profile
                  GestureDetector(
                    onTap: () => context.go('/profile/edit'),
                    child: Stack(alignment: Alignment.bottomRight, children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt,
                          size: 14, color: AppColors.primary),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  Text(authService.displayName, style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(authService.email, style: const TextStyle(
                    fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go('/profile/edit'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    ),
                    child: const Text('Edit Profile', style: TextStyle(fontSize: 13)),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              // Account Section
              _sectionLabel('Account'),
              _menuItem(context, Icons.person_outline, 'Edit Profile',
                'Update your name, phone and photo', '/profile/edit'),
              _menuItem(context, Icons.lock_outline, 'Password Manager',
                'Change or update your password', '/profile/password'),
              const SizedBox(height: 8),
              // Preferences Section 
              _sectionLabel('Preferences'),
              _menuItem(context, Icons.notifications_outlined, 'Notification Settings',
                'Control which alerts you receive', '/profile/notification-settings'),
              _menuItem(context, Icons.settings_outlined, 'Settings',
                'App theme, language, and preferences', '/profile/settings'),
              const SizedBox(height: 8),
              // Support Section 
              _sectionLabel('Support'),
              _menuItem(context, Icons.help_outline, 'Help Center',
                'FAQ and contact support', '/profile/help'),
              _menuItem(context, Icons.privacy_tip_outlined, 'Privacy Policy',
                'How we handle your data', '/profile/privacy'),
              _menuItem(context, Icons.calendar_today_outlined, 'Appointment History',
                'View all past and upcoming bookings', '/appointments'),
              const SizedBox(height: 16),
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity, height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context, authService),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Log Out', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }
 
  // Section label (grey heading above group)
  static Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label.toUpperCase(), style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.bold,
          color: AppColors.greyText, letterSpacing: 1.2)),
      ),
    );
  }
 
  // Reusable menu item card
  static Widget _menuItem(BuildContext context, IconData icon,
      String title, String subtitle, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
        subtitle: Text(subtitle, style: const TextStyle(
          fontSize: 12, color: AppColors.greyText)),
        trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: AppColors.greyText),
        onTap: () => context.go(route),
      ),
    );
  }
 
  // Logout confirmation dialog
  static Future<void> _showLogoutDialog(
      BuildContext context, AuthService authService) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out of DermCare?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.greyText)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await authService.logout();
      if (context.mounted) context.go('/welcome');
    }
  }
}