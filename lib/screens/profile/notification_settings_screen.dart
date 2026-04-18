import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
 
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override State<NotificationSettingsScreen> createState()
    => _NotificationSettingsScreenState();
}
 
class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Toggle values — default all ON
  bool _appointmentReminders = true;
  bool _appointmentConfirmed = true;
  bool _appointmentCancelled = true;
  bool _newDoctorAvailable   = false;
  bool _promotions           = false;
  bool _emailNotifications   = true;
  bool _loading              = false;
 
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }
 
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointmentReminders =
        prefs.getBool('notif_reminders') ?? true;
      _appointmentConfirmed =
        prefs.getBool('notif_confirmed') ?? true;
      _appointmentCancelled =
        prefs.getBool('notif_cancelled') ?? true;
      _newDoctorAvailable =
        prefs.getBool('notif_new_doctor') ?? false;
      _promotions =
        prefs.getBool('notif_promotions') ?? false;
      _emailNotifications =
        prefs.getBool('notif_email') ?? true;
    });
  }
 
  Future<void> _savePreferences() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_reminders', _appointmentReminders);
    await prefs.setBool('notif_confirmed', _appointmentConfirmed);
    await prefs.setBool('notif_cancelled', _appointmentCancelled);
    await prefs.setBool('notif_new_doctor', _newDoctorAvailable);
    await prefs.setBool('notif_promotions', _promotions);
    await prefs.setBool('notif_email', _emailNotifications);
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification preferences saved!'),
        backgroundColor: AppColors.success));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Settings', style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/profile')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _groupLabel('Appointments'),
            _toggleTile('Appointment Reminders',
              'Get reminded before your appointment',
              Icons.alarm_outlined, _appointmentReminders,
              (v) => setState(() => _appointmentReminders = v)),
            _toggleTile('Booking Confirmed',
              'When a doctor confirms your booking',
              Icons.check_circle_outline, _appointmentConfirmed,
              (v) => setState(() => _appointmentConfirmed = v)),
            _toggleTile('Booking Cancelled',
              'When an appointment is cancelled',
              Icons.cancel_outlined, _appointmentCancelled,
              (v) => setState(() => _appointmentCancelled = v)),
            const SizedBox(height: 12),
            _groupLabel('General'),
            _toggleTile('New Doctor Available',
              'When a new specialist joins DermCare',
              Icons.person_add_outlined, _newDoctorAvailable,
              (v) => setState(() => _newDoctorAvailable = v)),
            _toggleTile('Promotions & Offers',
              'Special deals and health tips',
              Icons.local_offer_outlined, _promotions,
              (v) => setState(() => _promotions = v)),
            const SizedBox(height: 12),
            _groupLabel('Communication'),
            _toggleTile('Email Notifications',
              'Receive updates via email',
              Icons.email_outlined, _emailNotifications,
              (v) => setState(() => _emailNotifications = v)),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Preferences',
              onPressed: _savePreferences,
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _groupLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(label, style: const TextStyle(
        fontSize: 13, fontWeight: FontWeight.bold,
        color: AppColors.greyText, letterSpacing: 1.1)),
    );
  }
 
  Widget _toggleTile(String title, String subtitle, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(
          fontSize: 12, color: AppColors.greyText)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}